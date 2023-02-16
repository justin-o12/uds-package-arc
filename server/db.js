const Pool = require('pg').Pool;

const pool = new Pool({
    "user": "postgres",
    "host": "postgres",
    "port": 5432,
    "database": "postgres",
    "password": "password"
})

module.exports = pool;