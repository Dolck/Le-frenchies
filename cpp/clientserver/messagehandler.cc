#include "server.h"
#include "connection.h"
#include "connectionclosedexception.h"
#include "exceptions.h"
#include "newsobjects.h"
#include "protocol.h"
#include "messagehandler.h"

#include <memory>
#include <iostream>
#include <string>
#include <stdexcept>
#include <cstdlib>

using namespace std;

int MessageHandler::readNumber(const shared_ptr<Connection>& conn) {
  expectInputChar(conn, Protocol::PAR_NUM);
	return readInteger(conn);
}

int MessageHandler::readInteger(const shared_ptr<Connection>& conn) {
  char byte1 = conn->read();
  char byte2 = conn->read();
  char byte3 = conn->read();
  char byte4 = conn->read();
  return (byte1 << 24) | (byte2 << 16) | (byte3 << 8) | byte4;
}

char MessageHandler::readChar(const shared_ptr<Connection>& conn) {
	return conn->read();
}

void MessageHandler::expectInputChar(const shared_ptr<Connection>& conn, const char& expected){
  char c = readChar(conn);
  //cout << "Excpected: " << (int)expected << " got: " << (int)c << endl;
  if(c != expected){
    throw ConnectionClosedException();
  }
}

string MessageHandler::readString(const shared_ptr<Connection>& conn) {
  expectInputChar(conn, Protocol::PAR_STRING);
  int nbrChars = readInteger(conn);
	string s;
	for (int i = 0; i < nbrChars; ++i){
		s += readChar(conn);
	}
	return s;
}

void MessageHandler::addNumberToBytesVector(vector<char>& bytes, const int& num){
  bytes.push_back(Protocol::PAR_NUM);
  addIntegerToBytesVector(bytes, num);
}

void MessageHandler::addIntegerToBytesVector(vector<char>& bytes, const int& num){
  bytes.push_back((num >> 24) & 0xFF);
  bytes.push_back((num >> 16) & 0xFF);
  bytes.push_back((num >> 8) & 0xFF);
  bytes.push_back(num & 0xFF);
}

void MessageHandler::addStringBytesToVector(vector<char>& bytes, const string& s){
  bytes.push_back(Protocol::PAR_STRING);
  addIntegerToBytesVector(bytes, s.size());
  for (char c : s) {
    bytes.push_back(c);
  }
}

void MessageHandler::writeByteVector(const shared_ptr<Connection>& conn, const vector<char>& bytes){
  for(char byte : bytes){
    conn->write(byte);
  }
}


