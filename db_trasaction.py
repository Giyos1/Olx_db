import psycopg2

db_name = 'g1'
username = 'postgres'
password = '12'
port = '5432'
host = 'localhost'


class DBConnector:
    def __init__(self, db_name=db_name, username=username, password=password, port=port, host=host):
        self.db_name = db_name
        self.username = username
        self.password = password
        self.port = port
        self.host = host

    def __enter__(self):
        self.conn = psycopg2.connect(dbname=db_name, user=username, password=password, host=host)
        self.conn.autocommit = False
        return self.conn

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type:
            self.conn.rollback()
            raise exc_val
        else:
            self.conn.commit()
        if self.conn:
            self.conn.close()


with DBConnector() as conn:
    cur = conn.cursor()

    cur.execute("""
        insert into transactions(from_account_id, to_account_id, amount)
        values (1, 2, 500.00);
        """)
    cur.execute("""
            update accounts
            set balance = balance - 500.00
            where account_id = 1;
        """)

    cur.execute(
        """update accounts
        set balance = balance + 500.00
        where account_id = (Select account_id from accounts where username = 'Bob' limit 1);
        """
    )

print('done')
