//
//  ConceptObjectSettingsViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/22/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConceptObjectConnections.h"

@class ConceptObject;

@interface ConceptObjectSettingsViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	ConceptObject *conceptObject;
	UIPopoverController *popover;
	ConceptObjectConnections *conceptObjectConnections;
}

@property (nonatomic, retain) ConceptObject *conceptObject;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) ConceptObjectConnections *conceptObjectConnections;

- (void)chooseBackgroundImage;

@end
