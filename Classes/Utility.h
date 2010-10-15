//
//  Utility.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APPLICATION_NAME	NSLocalizedString(@"Concept Map", @"")

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

#if FUNCTION_LOGGING
	#define LOG_RECT(r) NSLog(@"%s origin=(%.0f, %.0f), size=(%.0f, %.0f)", __FUNCTION__, r.origin.x, r.origin.y, r.size.width, r.size.height)
#else
	#define LOG_RECT(r) /* */
#endif

#if FUNCTION_LOGGING
	#define LOG_POINT(pt) NSLog(@"%s (%.0f, %.0f)", __FUNCTION__, pt.x, pt.y)
#else
	#define LOG_POINT(pt) /* */
#endif

#if FUNCTION_LOGGING
	#define LOG_CONCEPTOBJECT(co) NSLog(@"%s %@ o=(%@, %@), sz=(%@, %@)", __FUNCTION__, co.concept.title, co.concept.originX, co.concept.originY, co.concept.width, co.concept.height)
#else
	#define LOG_CONCEPTOBJECT(co) /* */
#endif

#define DATABASE	[DataController sharedDataController]

#define LAYER_NAME			@"layerName"
#define LAYER_NAME_OBJECT	@"conceptObject"
#define LAYER_NAME_TITLE	@"titleLayer"
#define LAYER_NAME_DELETE	@"deleteLayer"
#define LAYER_NAME_CONNECT	@"connectLayer"

typedef enum ColorSchemeConstantValues {
	ColorSchemeConstantBlue			= 0,
	ColorSchemeConstantPurple		= 1,
	ColorSchemeConstantYellow		= 2,
	ColorSchemeConstantGreen		= 3,	
	ColorSchemeConstantLightGreen	= 4,
	ColorSchemeConstantLightBlue	= 5,
	ColorSchemeConstantLightBrown	= 6,
	ColorSchemeConstantMAX
} ColorSchemeConstant;

@interface Utility : NSObject {

}

@end
