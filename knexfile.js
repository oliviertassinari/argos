const config = {
  development: {
    debug: true,
    client: 'postgresql',
    connection: {
      user: 'development',
      database: 'development',
    },
    pool: {
      min: 2,
      max: 10,
    },
    seeds: {
      directory: './seeds',
    },
  },
  test: {
    debug: false,
    client: 'postgresql',
    connection: {
      user: 'test',
      database: 'test',
    },
  },
  production: {
    client: 'postgresql',
    pool: {
      min: 2,
      max: 10,
    },
  },
};

if (process.env.DATABASE_URL) {
  const url = require('url');
  const pgProd = url.parse(process.env.DATABASE_URL);

  config.production.connection = {
    host: pgProd.hostname,
    port: pgProd.port,
    user: pgProd.auth.split(':')[0],
    password: pgProd.auth.split(':')[1],
    database: pgProd.path.substring(1),
    ssl: true,
  };
}

module.exports = config;
