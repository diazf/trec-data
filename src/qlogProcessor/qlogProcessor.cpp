#include <boost/algorithm/string.hpp>
#include <algorithm>
#include <iostream>
#include <fstream>
#include <string>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <unordered_set>
#include <vector>
void readStopwords(char *fn,std::unordered_set < std::string > &sw);
bool isNav(std::string &s);
void tokenize(std::string &l,std::unordered_set < std::string > &sw, std::vector < std::string > &v);

int
main(int argc, char *argv[]){
	signed char c = -1;
	int maxline = 1000;
	std::unordered_set < std::string > sw;
	while ((c = getopt (argc, argv, "n:S:")) != -1){
		switch(c){
			case ('S'):
			readStopwords(optarg,sw);
			break;			
		}
	}
	std::string lastOutput = "";
  for (std::string line; std::getline(std::cin, line);) {
		std::vector<std::string> fields;
		boost::split(fields, line, boost::is_any_of("\t\n\r"));
		std::string query = fields[1];
		for (int i = 0 ; i < query.size() ; i++) {
			if (isalnum(query[i])){
				query[i] = tolower(query[i]);				
			}
		}
		if (isNav(query)) continue;
		std::vector < std::string > tokens;
		tokenize(query,sw,tokens);
		if (tokens.size() > 0){
			std::string output = "";
			for (int i = 0 ; i < tokens.size() ; i++){
				if (i>0)output += " ";
				output += tokens[i];
			}
			if (output != lastOutput){
				std::cout << output << std::endl;
			}
			lastOutput = output;
		}
  }
	return 0;
	
}
void
readStopwords(char *fn,std::unordered_set < std::string > &sw){
  std::string line;
  std::ifstream fp (fn);
  if (fp.is_open()){
    while ( std::getline (fp,line) ){
			sw.insert(line);
    }
    fp.close();
  }else{
		std::cerr << "cannot open " << fn << std::endl;
  }
}

bool 
isNav(std::string &s){
	std::vector < std::string > navPatterns = {".com", ".net", ".org", "http", ".edu", "www.", ".gov"};
	for (int i = 0 ; i < navPatterns.size() ; i++) {
		if (s.find(navPatterns[i])!=std::string::npos){
			return true;
		}
	}
	return false;
}
void
tokenize(std::string &l,std::unordered_set < std::string > &sw, std::vector < std::string > &v){
	std::string w = "";
	bool skip = false;
	for (int i = 0 ; i < l.size() ; i++){
		if (isalpha(l[i])){
			if (skip==false) w+=l[i];
		}else if (isdigit(l[i])){
			skip = true;
			w = "";
		}else{
			if ((w.size() > 0) && (sw.find(w) == sw.end())){
				v.push_back(w);
			}
			w = "";
			skip = false;
		}
	}
	if ((w.size() > 0) && (sw.find(w) == sw.end())){
		v.push_back(w);
		w = "";
		skip = false;
	}
}
