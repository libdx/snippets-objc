//
//  log.h
//  snippets-objc
//
//  Created by Alexander Ignatenko on 10/22/12.
//  Copyright (c) 2012 Alexander Ignatenko. All rights reserved.
//

#ifdef DEBUG
	#define FULL_FILENAME __FILE__
	#define SHORT_FILENAME (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
	// Provide you own option inside user define ifdef..endif
	#define FILENAME SHORT_FILENAME

	#define trace(...) NSLog(__VA_ARGS__)
	#define log_sel() NSLog(@"[self:%p] %s", self, __PRETTY_FUNCTION__)
	#define log_func() NSLog(@"%s", __PRETTY_FUNCTION__)
	#define log_warning(...) NSLog(@"[WARNING] %s:%s:%d %@", \
		FILENAME, __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
	#define log_error(e) NSLog(@"[ERROR] %s:%s:%d %@", \
		FILENAME, __PRETTY_FUNCTION__, __LINE__, [e localizedDescription])
	#define log_error_v(e, ...) NSLog(@"[ERROR] %s:%s:%d %@. %@", \
		FILENAME, __PRETTY_FUNCTION__, __LINE__, [e localizedDescription], [NSString stringWithFormat:__VA_ARGS__])

    #define LogOnError(e, statement) {NSError *(e); if (!statement) log_error(e);}
#endif // DEBUG
#ifdef RELEASE
	#define trace(...)
	#define log_sel()
	#define log_func()
	#define log_warning(...)
	#define log_error(e)
	#define log_error_v(e, ...)
    #define LogOnError(e, statement)
#endif // RELEASE

