//
//  Application.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Application :  NSManagedObject  
{
}

@property (nonatomic, retain) NSSet* newRelationship;

@end


@interface Application (CoreDataGeneratedAccessors)
- (void)addNewRelationshipObject:(NSManagedObject *)value;
- (void)removeNewRelationshipObject:(NSManagedObject *)value;
- (void)addNewRelationship:(NSSet *)value;
- (void)removeNewRelationship:(NSSet *)value;

@end

