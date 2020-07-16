//
//  EquationSnipCell.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquationSnip.h"

NS_ASSUME_NONNULL_BEGIN

@interface EquationSnipCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *equationSnipName;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedTimeLabel;
@property (strong, nonatomic) EquationSnip *equationSnip;
@end

NS_ASSUME_NONNULL_END
