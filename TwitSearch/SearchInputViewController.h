//
//  SearchInputViewController.h
//  TwitSearch
//
//  Created by slader on 22/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchInputViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *searchTextField;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
