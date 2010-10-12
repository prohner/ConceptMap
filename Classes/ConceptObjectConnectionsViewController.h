//
//  ConceptObjectConnectionsViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/11/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@class ConceptObject;

@interface ConceptObjectConnectionsViewController : UITableViewController {
	ConceptObject *conceptObject;
	UIPopoverController *popover;
}

@property (nonatomic, retain) ConceptObject *conceptObject;
@property (nonatomic, retain) UIPopoverController *popover;
@end
