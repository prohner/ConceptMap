//
//  Utility.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FUNCTION_LOGGING		1
#define MEMORY_WARNING_LOGGING		1

#if MEMORY_WARNING_LOGGING
	#define MEMORY_LOG(fmt, ...) NSLog(@"%s " fmt, __FUNCTION__, ## __VA_ARGS__)
#else
	#define MEMORY_LOG(fmt, ...) /* */
#endif

#if FUNCTION_LOGGING
	#define FUNCTION_LOG(fmt, ...) NSLog(@"%s " fmt, __FUNCTION__, ## __VA_ARGS__)
#else
	#define FUNCTION_LOG(fmt, ...) /* */
#endif

#define DATABASE	[DataController sharedDataController]

#define LAYER_NAME			@"layerName"
#define LAYER_NAME_OBJECT	@"conceptObject"
#define LAYER_NAME_TITLE	@"titleLayer"
#define LAYER_NAME_DELETE	@"deleteLayer"

typedef enum ColorSchemeConstantValues {
	ColorSchemeConstantBlue		= 0,
	ColorSchemeConstantPurple	= 1,
	ColorSchemeConstantYellow	= 2,
	ColorSchemeConstantGreen	= 3	
} ColorSchemeConstant;

@interface Utility : NSObject {

}

@end
