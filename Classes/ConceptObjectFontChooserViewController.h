//
//  ConceptObjectFontChooserViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/3/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConceptObject;

@interface ConceptObjectFontChooserViewController : UITableViewController {
	ConceptObject *conceptObject;
	UITableViewCell *changeFontSizeButtonsCell;
}

@property (nonatomic, retain) ConceptObject *conceptObject;
@property (nonatomic, retain) IBOutlet UITableViewCell *changeFontSizeButtonsCell;

- (IBAction)makeFontSizeBigger:(id)sender;
- (IBAction)makeFontSizeSmaller:(id)sender;
- (void)stepFontSize:(int)direction;

@end
