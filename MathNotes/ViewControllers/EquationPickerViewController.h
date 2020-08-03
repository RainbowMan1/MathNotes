//
//  EquationPickerViewController.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/16/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquationSnip.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EquationPickerDelegate

- (void)didPickEquationSnip:(EquationSnip *)equationSnip withMode:(NSString *) mode;

@end

@interface EquationPickerViewController : UIViewController

@property (nonatomic, weak) id<EquationPickerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
