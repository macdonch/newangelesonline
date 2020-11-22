FROM ubuntu
RUN apt-get upgrade
RUN apt-get install python2-pip.noarch python-devel.x86_64
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
