
WITH email_metrics AS (
    SELECT
        sp.operating_system
        ,COUNT(DISTINCT es.id_message) AS sent_msg
        ,COUNT(DISTINCT eo.id_message) AS open_msg
        ,COUNT(DISTINCT ev.id_message) AS visit_msg

    FROM `DA.email_sent` es
    JOIN `DA.account` a ON es.id_account = a.id
    JOIN `DA.account_session` acs ON a.id = acs.account_id
    JOIN `DA.session_params` sp ON acs.ga_session_id = sp.ga_session_id

    LEFT JOIN `DA.email_open` eo ON es.id_message = eo.id_message
    LEFT JOIN `DA.email_visit` ev ON es.id_message = ev.id_message

    WHERE a.is_unsubscribed = 0
    GROUP BY sp.operating_system
)

SELECT
    operating_system
    ,sent_msg
    ,open_msg
    ,visit_msg
    ,SAFE_DIVIDE(open_msg, sent_msg) * 100 AS open_rate
    ,SAFE_DIVIDE(visit_msg, sent_msg) * 100 AS click_rate
    ,SAFE_DIVIDE(visit_msg, open_msg) * 100 AS ctor

FROM email_metrics
ORDER BY sent_msg DESC;
