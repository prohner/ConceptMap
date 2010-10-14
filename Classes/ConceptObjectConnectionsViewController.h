//
//  ConceptObjectConnectionsViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/11/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "ConceptObjectConnections.h"

@class ConceptObject;

@interface ConceptObjectConnectionsViewController : UITableViewController {
	ConceptObject *conceptObject;
	UIPopoverController *popover;
	NSMutableArray *connectedObjects;
	ConceptObjectConnections *conceptObjectConnections;
}

@property (nonatomic, retain) ConceptObject *conceptObject;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) ConceptObjectConnections *conceptObjectConnections;
@end
