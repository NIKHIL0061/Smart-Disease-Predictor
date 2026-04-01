from flask import Flask, render_template, request
import mysql.connector

app = Flask(__name__)

# Database configuration – UPDATE YOUR PASSWORD HERE!
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'password',   # <-- change this
    'database': 'disease_predictor'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id, name FROM symptoms ORDER BY name")
    symptoms = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('index.html', symptoms=symptoms)

@app.route('/predict', methods=['POST'])
def predict():
    selected_symptom_ids = request.form.getlist('symptoms')
    if not selected_symptom_ids:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT id, name FROM symptoms ORDER BY name")
        symptoms = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('index.html', error="Please select at least one symptom.", symptoms=symptoms)

    selected_symptom_ids = [int(id) for id in selected_symptom_ids]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    placeholders = ','.join(['%s'] * len(selected_symptom_ids))
    query = f"""
        SELECT 
            d.id,
            d.name,
            d.description,
            COUNT(ds.symptom_id) AS matched_symptoms,
            (SELECT COUNT(*) FROM disease_symptoms WHERE disease_id = d.id) AS total_symptoms
        FROM diseases d
        JOIN disease_symptoms ds ON d.id = ds.disease_id
        WHERE ds.symptom_id IN ({placeholders})
        GROUP BY d.id
        ORDER BY matched_symptoms DESC
    """

    cursor.execute(query, selected_symptom_ids)
    results = cursor.fetchall()
    cursor.close()

    # Calculate match percentage for each disease
    predictions = []
    for row in results:
        total = row['total_symptoms'] or 1
        percentage = (row['matched_symptoms'] / total) * 100
        predictions.append({
            'name': row['name'],
            'description': row['description'],
            'matched': row['matched_symptoms'],
            'total': row['total_symptoms'],
            'percentage': round(percentage, 2)
        })

    # Only show top 2 diseases
    predictions = predictions[:2]

    # Fetch precautions BEFORE closing connection
    for prediction in predictions:
        cursor2 = conn.cursor(dictionary=True)
        cursor2.execute("""
            SELECT p.precaution FROM precautions p
            JOIN diseases d ON p.disease_id = d.id
            WHERE d.name = %s
        """, (prediction['name'],))
        precaution_rows = cursor2.fetchall()
        prediction['precautions'] = [row['precaution'] for row in precaution_rows]
        cursor2.close()

    conn.close()  # Close AFTER all queries are done

    return render_template('result.html', predictions=predictions, symptoms_count=len(selected_symptom_ids))

if __name__ == '__main__':
    app.run(debug=True)