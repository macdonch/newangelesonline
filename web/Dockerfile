FROM ubuntu:18.04
RUN apt-get upgrade
RUN apt-get install python3-pip
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
