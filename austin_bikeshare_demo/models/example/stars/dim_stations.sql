WITH station_base AS (
    SELECT
        station_id,
        name AS station_name,
        status,
        address,
    FROM {{ source('austin_bikeshare', 'bikeshare_stations') }}
),

trip_starts AS (
    SELECT
        CAST(start_station_id AS INT64) AS station_id,
        AVG(duration_minutes * 60) AS avg_duration
    FROM {{ source('austin_bikeshare', 'bikeshare_trips') }}
    WHERE start_station_id IS NOT NULL
    GROUP BY start_station_id
)

SELECT
    sb.station_id,
    sb.station_name,
    sb.status,
    sb.address,
    ts.avg_duration
FROM station_base sb
LEFT JOIN trip_starts ts
    ON sb.station_id = ts.station_id
ORDER BY avg_duration DESC
  