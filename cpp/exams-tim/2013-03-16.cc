//This file should not be compiled. Probably wouldn't work anyway ;)
using namespace std;

//Q1:
//a)
bool odd_partitioned(const vector<int>& v){
	return is_partitioned(v.begin(), v.end(), [](int i){ return i%2 == 1 ;});
}

//b)
template <typename InputIt, typename UnaryPredicate>
bool is_partitioned(InputIt first, InputIt last, UnaryPredicate p){
	while(first != last && p(*first))
		++first;

	while(first != last && !p(*first))
		++first;

	return first == last;
}

//Q2:
class TimeCompare{
public:
	bool operator()(Event* e1, Event* e2) const{
		return e1->getTime() > e2->getTime();
	}
};
priority_queue<Event*, vector<Event*>, TimeCompare> queue;

void insertEvent(Event* e) {
	queue.push(e);
}

void actionLoop() {
	while(!queue.empty()){
		queue.top()->action();
		delete queue.top();
		queue.pop();
	}
}

//Q3:
int main() {
	using namespace std;
	String line;
	while (getline(cin, line)) {
		for (String::word_iterator wi = line.wi_begin();
			wi != line.wi_end(); ++wi) {
			cout << *wi << " "; // *wi is a std::string object
		}
		cout << endl;
	}
}
//header:
class WordIterator{
public:
	WordIterator(const String& s, size_t p);
	bool operator!=(const WordIterator& wi) const;
	std::string operator*();
	WordIterator& operator++();
private:
	const String& str;
	size_t position;
};

class String {
	friend class WordIterator;
public:
	typedef WordIterator word_iterator;
	word_iterator wi_begin() const;
	word_iterator wi_end() const;
	//...
private:
	char* chars; // array of characters
	size_t n; // the number of characters in the array
};

//code:
WordIterator::WordIterator(const String& s, size_t p) : str(s), position(p) {
	for (int i = 0; i < str.n && str.chars[i] == ' '; ++i) {
		++position;
	}
}

bool WordIterator::operator!=(const WordIterator& wi){
	return position != wi.position || &str != &wi.str;
}

std::string WordIterator::operator*(){
	std::string s;
	while(position < str.n && str.chars[position] != ' '){
		s += str.chars[i];
		++position;
	}
	return s;
}

WordIterator& operator++() {
	for (int i = 0; i < str.n && str.chars[i] == ' '; ++i) {
		++position;
	}
}

//Q4
int main()
{
	ifstream infile("words.txt");
	istream_iterator<string> iBegin(infile);
	istream_iterator<string> iEnd();

	std::vector<string> words(iBegin, iEnd);

	for_each(words.begin(), words.end(), [](string& s){
		std::transform(s.begin(), s.end(), s.begin(), ::tolower);
		std::reverse(s.begin(), s.end());
	});

	std::sort(words.begin(), words.end());
	auto it = unique(words.begin(), words.end());
	words.resize(std::distance(words.begin(), it));
	
	for_each(words.begin(), words.end(), [](string& s){
		std::reverse(s.begin(), s.end());
	});

	ofstream ofile("backwords.txt");
	std::copy(words.begin(), words.end(), ostream_iterator<string>(ofile, "\n"));
}