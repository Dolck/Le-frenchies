/*
Palindrome
*/
#include <string>
#include <iostream>

using namespace std;

bool palindrome(const string& str){
	string reverse = string ( str.rbegin(), str.rend() );
	return reverse == str;
}

void printIfPal(const string& str) {
	if (palindrome(str)){
		cout << str << " is a palindrome" << endl;
	}else{
		cout << str << " is NOT a palindrome" << endl;
	}
}

int main(){
	cout << "Type your string: ";
	string input;
	while(cin >> input){
		printIfPal(input);
		cout << "And another one: ";
	}
}