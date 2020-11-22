FROM ubuntu
RUN apt-get upgrade
RUN apt install python-pip python-devel.x86_64
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
