# TakeMeThere API
A REST API for the TakeMeThere app, written in Elixir and Phoenix

## Endpoints

### Health Check

*GET* `/api/health`

#### Response
200 OK
```json
{
  "status": "UP"
}
```

### Register

*POST* `/api/auth/register`

```json
{
    "email": "test@test3.com",
    "first_name": "Test",
    "last_name": "T",
    "password": "test123"
}
```

#### Response
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsI..."
}
```

### Login

*POST* `/api/auth/login`

```json
{
    "email": "test@test3.com",
    "password": "test123"
}
```

#### Response
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsI..."
}
```

### Google Register

*POST* `/api/auth/register/google`

```json
{
    "token": "eyjgbvyur..."
}
```

#### Response
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsI..."
}
```

### Google Login

*POST* `/api/auth/login/google`

```json
{
    "token": "eyjgbvyur..."
}
```

#### Response
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsI..."
}
```

### Search Locations

#### Headers
`Authorization: {token here}`

*GET* `/api/locations`
*GET* `/api/locations=name=rome`

#### Response
```json
[
    {
        "country": "Italy",
        "id": 2138,
        "name": "Rome"
    },
    {
        "country": "Russian Federation",
        "id": 2774,
        "name": "Kostroma"
    },
    {
        "country": "Norway",
        "id": 2509,
        "name": "Tromsø"
    },
    {
        "country": "Australia",
        "id": 283,
        "name": "Roma"
    },
    {
        "country": "Dominican Republic",
        "id": 2182,
        "name": "La Romana"
    }
]
```