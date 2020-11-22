FROM ubuntu
RUN apt-get upgrade
RUN apt install python3-pip
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
