
typedef struct {
    char* appname
} SudsPtr;

SudsPtr suds_register(char* appname, void(*receiver)(char*));
void suds_send(SudsPtr self, char* appname, char* msg);
void suds_disconnect(SudsPtr self);

