"""
Contains which files to regex and regex patternself.
Change these to fit your need.
"""
PATH_TO_SKILLS = "/var/lib/snips/skills/" # In docker container

SKILLS = {
    "<skill-name>": [
        [
            "<path-to-file-based-from-PATH_TO_SKILLS>",
            ("<regex-pattern>", "<replace-pattern-with>"),
        ],
        [
            "<another-file-to-edit-for-skill>",
            ("<regex-pattern>", "<replace-pattern-with>"),
        ],
    ],
    "owm": [ # Example for app Weather-en, https://console.snips.ai/store/en/skill_W5oo75KMngkl
        [
            "snips-skill-owm/action-owm.py",
            ('MQTT_IP_ADDR = "localhost"', 'MQTT_IP_ADDR = "192.168.1.1"'), # Change ip for MQTT broker
        ],
        [
            "snips-skill-owm/config.ini",
            ('^.+\Z', "[global]\nlocale=en_US\n[secret]\ndefault_location=Karlskrona\napi_key=000000000000"), # Set end-user parameters in config
        ],
    ],
}