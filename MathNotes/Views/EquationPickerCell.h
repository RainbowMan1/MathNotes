//
//  EquationPickerCell.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/31/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquationSnip.h"
#import "MTMathUILabel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PopoverEquationCellDelegate

- (void)tapOnMenu:(UIButton *)button forEquationSnip:(EquationSnip *) equationSnip;

@end

@interface EquationPickerCell : UITableViewCell

@property (nonatomic, weak) id<PopoverEquationCellDelegate> delegate;
@property (nonatomic, strong) EquationSnip *equationSnip;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet MTMathUILabel *equationPreview;

@end

NS_ASSUME_NONNULL_END
