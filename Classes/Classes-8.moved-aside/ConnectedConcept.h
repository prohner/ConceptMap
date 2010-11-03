//
//  ConnectedConcept.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Concept;

@interface ConnectedConcept :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * objectURL;
@property (nonatomic, retain) Concept * connectedConcept;

@end



