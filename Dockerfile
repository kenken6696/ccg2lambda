FROM coqorg/coq:8.18
RUN sudo apt update && sudo apt install -y wget python3-pip

RUN echo 'alias python="python3"' | sudo tee -a $HOME/.bashrc

WORKDIR /app
ADD . /app

# install ccg2lambda specific dependencies
RUN pip3 install simplejson pyyaml lxml -I nltk==3.0.5
RUN pip3 install lxml
RUN python3 -c "import nltk; nltk.download('wordnet')"
RUN unzip -d $HOME/nltk_data/corpora $HOME/nltk_data/corpora/wordnet.zip
## ify https://github.com/nltk/nltk/issues/2951

# install english-ccg(depccg) TODO https://github.com/masashi-y/depccg
#RUN pip3 install cython numpy 
#RUN pip3 install depccg

# install japanese-ccg
RUN sudo apt install -y default-jre bc
WORKDIR /build
ADD https://github.com/mynlp/jigg/archive/v-0.4.tar.gz /build/v-0.4.tar.gz
RUN sudo tar xzf v-0.4.tar.gz

RUN mkdir -p /app/parsers/jigg-v-0.4/jar 
RUN cp /build/jigg-v-0.4/jar/jigg-0.4.jar /app/parsers/jigg-v-0.4/jar
ADD https://github.com/mynlp/jigg/releases/download/v-0.4/ccg-models-0.4.jar /app/parsers/jigg-v-0.4/jar/
RUN echo "/app/parsers/jigg-v-0.4" |sudo tee /app/ja/jigg_location.txt
RUN echo "jigg:/app/parsers/jigg-v-0.4" |sudo tee -a /app/ja/parser_location_ja.txt
## this above cmd is same as $HOME/ccg2lambda/ja/download_dependencies.sh
## cd /app/ && sudo ja/rte_ja_mp.sh ja/sample_ja.txt ja/semantic_templates_ja_emnlp2016.yaml
