import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :b5g_app_objectdetect, B5gAppObjectdetectWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "0cKixUcnJL75Uce2MprM0TI8fAfRA8Hvauct1UWmJUdQ/rOruqU4N2DEHBLkqCJB",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
