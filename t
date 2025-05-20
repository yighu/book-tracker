# app.py
from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from math import ceil

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///books.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Book(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    author = db.Column(db.String(100), nullable=False)
    year = db.Column(db.Integer)
    description = db.Column(db.Text)

@app.before_first_request
def create_tables():
    db.create_all()

@app.route('/')
def index():
    page = request.args.get('page', 1, type=int)
    keyword = request.args.get('q', '')
    query = Book.query
    if keyword:
        query = query.filter(Book.title.contains(keyword) | Book.author.contains(keyword))
    books = query.order_by(Book.id.desc()).paginate(page=page, per_page=5)
    return render_template('index.html', books=books, keyword=keyword)

@app.route('/create', methods=['GET', 'POST'])
def create():
    if request.method == 'POST':
        new_book = Book(
            title=request.form['title'],
            author=request.form['author'],
            year=request.form['year'],
            description=request.form['description']
        )
        db.session.add(new_book)
        db.session.commit()
        return redirect(url_for('index'))
    return render_template('create.html')

@app.route('/update/<int:id>', methods=['GET', 'POST'])
def update(id):
    book = Book.query.get_or_404(id)
    if request.method == 'POST':
        book.title = request.form['title']
        book.author = request.form['author']
        book.year = request.form['year']
        book.description = request.form['description']
        db.session.commit()
        return redirect(url_for('index'))
    return render_template('update.html', book=book)

@app.route('/delete/<int:id>', methods=['POST'])
def delete(id):
    book = Book.query.get_or_404(id)
    db.session.delete(book)
    db.session.commit()
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)

# requirements.txt
Flask==2.3.2
Flask-SQLAlchemy==3.1.1

# templates/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Book List</title>
</head>
<body>
    <h1>Book List</h1>
    <form method="get">
        <input type="text" name="q" placeholder="Search by title or author" value="{{ keyword }}">
        <button type="submit">Search</button>
        <a href="{{ url_for('create') }}">Add New Book</a>
    </form>
    <ul>
        {% for book in books.items %}
            <li>
                <strong>{{ book.title }}</strong> by {{ book.author }} ({{ book.year }})<br>
                {{ book.description }}<br>
                <a href="{{ url_for('update', id=book.id) }}">Edit</a>
                <form method="post" action="{{ url_for('delete', id=book.id) }}" style="display:inline">
                    <button type="submit">Delete</button>
                </form>
            </li>
        {% endfor %}
    </ul>
    <div>
        {% if books.has_prev %}<a href="?page={{ books.prev_num }}&q={{ keyword }}">Previous</a>{% endif %}
        Page {{ books.page }} of {{ books.pages }}
        {% if books.has_next %}<a href="?page={{ books.next_num }}&q={{ keyword }}">Next</a>{% endif %}
    </div>
</body>
</html>

# templates/create.html
<!DOCTYPE html>
<html>
<head>
    <title>Add Book</title>
</head>
<body>
    <h1>Add New Book</h1>
    <form method="post">
        Title: <input type="text" name="title"><br>
        Author: <input type="text" name="author"><br>
        Year: <input type="number" name="year"><br>
        Description:<br><textarea name="description"></textarea><br>
        <button type="submit">Create</button>
    </form>
    <a href="{{ url_for('index') }}">Back to list</a>
</body>
</html>

# templates/update.html
<!DOCTYPE html>
<html>
<head>
    <title>Edit Book</title>
</head>
<body>
    <h1>Edit Book</h1>
    <form method="post">
        Title: <input type="text" name="title" value="{{ book.title }}"><br>
        Author: <input type="text" name="author" value="{{ book.author }}"><br>
        Year: <input type="number" name="year" value="{{ book.year }}"><br>
        Description:<br><textarea name="description">{{ book.description }}</textarea><br>
        <button type="submit">Update</button>
    </form>
    <a href="{{ url_for('index') }}">Back to list</a>
</body>
</html>

