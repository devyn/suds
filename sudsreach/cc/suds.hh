using namespace std;
class Suds {
public:
    Suds(char* appname, void(*receiver)(char*));
    void send(char* appname, char* msg);
    void disconnect();
};
