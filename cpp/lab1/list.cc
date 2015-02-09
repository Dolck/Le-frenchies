#include <iostream>
#include "list.h"

using namespace std;

List::List() : first(nullptr){
}

List::~List() {
	Node* current = first;
	while(current != nullptr){
		Node* next = current->next;
		delete current;
		current = next;
	}
}

bool List::exists(int d) const {
	Node* current = first;
	while(current != nullptr){
		if(current->value == d){
			return true;
		}
		current = current->next;
	}
	return false;
}

int List::size() const {
	int size (0);
	Node* current = first;
	while (current != nullptr){
		++size;
		current = current->next;
	}

	return size;
}

bool List::empty() const {
	return first == nullptr;
}

void List::insertFirst(int d) {
	first = new Node(d, first);
}

void List::remove(int d, DeleteFlag df) {
	Node* current = first;
	Node* prev = nullptr;
	while(current != nullptr){
		if((df == DeleteFlag::LESS && current->value < d) ||
			(df == DeleteFlag::EQUAL && current->value == d) ||
			(df == DeleteFlag::GREATER && current->value > d)){

			if(prev == nullptr){
				first = current->next;
			}else{
				prev->next = current->next;
			}

			delete current;

			break;
		}

		prev = current;
		current = current->next;
	}
}

void List::print() const {
	Node* current = first;
	cout << "[" ;
	if(current != nullptr){
		while(current->next != nullptr){
			cout << current->value << ", ";
			current = current->next;
		}
		cout << current->value;
	}
	cout << "]";
}

