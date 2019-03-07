FROM debian:stretch-slim
ARG AUDIO_GROUP
ENV DEBIAN_FRONTEND "noninteractive"

RUN sed -i "s#deb http://deb.debian.org/debian stretch main#deb http://deb.debian.org/debian stretch main non-free#g" /etc/apt/sources.list && \
    sed -i "s#deb http://security.debian.org/debian-security stretch/updates main#deb http://security.debian.org/debian-security stretch/updates main non-free#g" /etc/apt/sources.list && \
    sed -i "s#deb http://deb.debian.org/debian stretch-updates main#deb http://deb.debian.org/debian stretch-updates main non-free#g" /etc/apt/sources.list && \
    apt-get update &&  \
    apt-get dist-upgrade -y && \
    apt-get install -qy software-properties-common && \
    apt-get install apt-transport-https

RUN apt-get install -y nano

RUN apt-get install -y dirmngr && \
    bash -c 'echo "deb https://debian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list'

RUN apt-key adv --keyserver gpg.mozilla.org --recv-keys F727C778CCB0A455 && \
    apt-get update && \
    apt-get install -y alsa-utils python-pip git \
    snips-platform-voice \
    snips-dialogue \
    snips-watch \
    snips-audio-server \
    snips-asr \
    snips-hotword \
    snips-nlu \
    snips-template snips-skill-server \
    pulseaudio \
    snips-tts && \
    apt-get -y autoclean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* && \
    pip install virtualenv

# Pulse audio https://docs.snips.ai/articles/platform/pulseaudio
RUN set -x && \
	usermod -aG snips-skills-admin root && \
    usermod -aG audio _snips && \
    usermod -aG audio pulse
    # groupadd -g $AUDIO_GROUP audio && \

COPY edit_skills.py edit_skills.py
COPY local_files/skills_to_edit.py skills_to_edit.py
COPY start.sh start.sh

CMD ["bash","/start.sh"]