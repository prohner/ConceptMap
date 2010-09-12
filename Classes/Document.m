// 
//  Document.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Document.h"

#import "Application.h"
#import "Concept.h"

@implementation Document 

@dynamic created;
@dynamic title;
@dynamic lastSaved;
@dynamic application;
@dynamic concepts;

- (void)awakeFromInsert {
	[self setValue:[NSDate date] forKey:@"created"];
	[self setValue:[NSDate date] forKey:@"lastSaved"];
}

- (void)willSave {
    [self setPrimitiveValue: [NSDate date] forKey: @"lastSaved"];
}

@end
