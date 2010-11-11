//
//  ActionsViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/29/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Concept.h"

@class ConceptMapView;
@class ConceptObjectColorSet;

@interface ActionsViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
	ConceptMapView *conceptMapView;
}

@property (nonatomic, retain) ConceptMapView *conceptMapView;

- (void)sendEmailIncludingImage:(BOOL)includeImage andList:(BOOL)includeList;
- (NSString *)conceptMapAsList;
- (NSString *)concepts:(NSSet *)concepts indented:(NSString *)indent;
- (NSString *)stringForConcept:(Concept *)concept withIndent:(NSString *)indent;
- (NSString *)borderInfoWithColor:(ConceptObjectColorSet *)conceptObjectColorSet;
- (void)sendEmailFeedback;

@end
