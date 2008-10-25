
struct SudsPtr {
    char* appname
};

struct SudsPtr suds_register(char* appname, void(*receiver)(char*));
void suds_send(struct SudsPtr self, char* appname, char* msg);
void suds_disconnect(struct SudsPtr self);

