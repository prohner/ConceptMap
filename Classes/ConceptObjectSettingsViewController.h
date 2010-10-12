//
//  ConceptObjectSettingsViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/22/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConceptObject;

@interface ConceptObjectSettingsViewController : UITableViewController {
	ConceptObject *conceptObject;
	UIPopoverController *popover;
}

@property (nonatomic, retain) ConceptObject *conceptObject;
@property (nonatomic, retain) UIPopoverController *popover;

@end
