from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from flask_migrate import Migrate
from werkzeug.security import generate_password_hash
import os
from urllib.parse import quote_plus  # Used to safely encode password

db = SQLAlchemy()
migrate = Migrate()


def build_database_uri():
    database_url = os.getenv('DATABASE_URL')
    if database_url:
        return database_url

    db_host = os.getenv('DATABASE_HOST')
    db_port = os.getenv('DATABASE_PORT', '5432')
    db_name = os.getenv('DATABASE_NAME')
    db_user = os.getenv('DATABASE_USER')
    db_password = os.getenv('DATABASE_PASSWORD')

    if db_host and db_user and db_name and db_password:
        encoded_password = quote_plus(db_password)
        return (
            f"postgresql://{db_user}:{encoded_password}@{db_host}:{db_port}/{db_name}"
        )

    return 'postgresql://taskapp_user:taskapp_password@localhost:5432/taskapp'


def register_commands(app):
    @app.cli.command('seed-default-users')
    def seed_default_users():
        """Seed demo users once after migrations complete."""
        from app.models import User

        seed_enabled = os.getenv('TASKAPP_SEED_DEFAULT_USERS', 'false').lower() == 'true'
        if not seed_enabled:
            print('Default user seeding disabled')
            return

        users = [
            (
                os.getenv('TASKAPP_ADMIN_USERNAME', 'admin'),
                os.getenv('TASKAPP_ADMIN_PASSWORD'),
            ),
            (
                os.getenv('TASKAPP_DEMO_USERNAME', 'student1'),
                os.getenv('TASKAPP_DEMO_PASSWORD'),
            ),
        ]

        for username, password in users:
            if not username or not password:
                continue
            existing = User.query.filter_by(username=username).first()
            if existing:
                continue
            db.session.add(User(username=username, password_hash=generate_password_hash(password)))

        db.session.commit()
        print('Default users seeded idempotently')


def create_app():
    app = Flask(__name__)

    app.config['SQLALCHEMY_DATABASE_URI'] = build_database_uri()
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    # Secret key for sessions / JWT (use a strong random value in production)
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')

    db.init_app(app)
    migrate.init_app(app, db)
    CORS(app)

    from app.routes import api_bp
    app.register_blueprint(api_bp, url_prefix='/api')
    register_commands(app)

    return app
