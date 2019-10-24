//
//  ChainView.m
//  BTE
//
//  Created by sophie on 2018/11/14.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "ChainView.h"

@implementation ChainView

- (instancetype)initWithFrame:(CGRect)frame WithNameArray:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KBGCell;
        if(array.count > 0){
            self.buttonArray = [NSMutableArray arrayWithCapacity:array.count];
            CGFloat labelWidth = SCREEN_WIDTH / array.count;
            for (int i = 0 ; i< array.count ; i++ ) {
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(i *labelWidth, 0, labelWidth, 12)];
                nameLabel.font = UIFontRegularOfSize(12);
                nameLabel.textColor = BHHexColorAlpha(@"626A75", 0.6);
                nameLabel.text = [NSString stringWithFormat:@"%@",array[i]];
                nameLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:nameLabel];
                
                UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(i *labelWidth, nameLabel.height + 8, labelWidth, 16)];
                valueLabel.font = UIFontRegularOfSize(16);
                valueLabel.textColor = BHHexColor(@"626A75");
//                valueLabel.text = [NSString stringWithFormat:@"%@",array[i]];
                valueLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:valueLabel];
                
                [self.buttonArray addObject:valueLabel];
                
                UIView *lineView = [UIView new];
                lineView.frame = CGRectMake((i +1)*labelWidth, (36 -20)/2, 1, 20);
                lineView.backgroundColor = BHHexColor(@"E6EBF0");
                [self addSubview:lineView];
            }
        }
    }
    return self;
}

- (void)setValueForName:(NSArray *)valueArray{
    if (valueArray != nil && valueArray.count > 0) {
        for (int i = 0; i < self.buttonArray.count; i++) {
            UILabel *tempValueLabel = self.buttonArray[i];
            tempValueLabel.text = [NSString stringWithFormat:@"%@",valueArray[i]];
            if (self.tag ==100) {
                if (i == 1) {
                    tempValueLabel.textColor = RoseColor;
                }
                if (i == 2) {
                    tempValueLabel.textColor = [UIColor colorWithHexString:@"FE413F"];;
                }
                if (i == 3) {
                    double change = [valueArray[i] doubleValue];
                    
                    if ( change > 0) {
                       tempValueLabel.textColor  = RoseColor;
                        tempValueLabel.text = [NSString stringWithFormat:@"%.2f%%",change * 100];
                    }else{
                        tempValueLabel.textColor  = [UIColor colorWithHexString:@"FE413F"];
                        tempValueLabel.text = [NSString stringWithFormat:@"%.2f%%",change * 100];
                    }
                    
                }
            }
                
            if (self.tag ==101) {
                if (i == 1) {
                    tempValueLabel.textColor = [UIColor colorWithHexString:@"FE413F"];
                }
                
                NSString *numStr = [NSString stringWithFormat:@"%.0f",[valueArray[i] floatValue]];
//                if (i == 0 || i== 1) {
                    NSMutableAttributedString *string;
                    if (numStr.length > 8) {//亿
                        string =  [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%.2f亿",[numStr floatValue]/100000000]];
                    }else if (numStr.length > 4 && (numStr.length) <= 8) {//万
                        string =  [[NSMutableAttributedString alloc] initWithString:  [NSString stringWithFormat:@"%.2f万",[numStr floatValue]/100000000]];
                    }else {
                        string =  [[NSMutableAttributedString alloc] initWithString:  [NSString stringWithFormat:@"%.2f",[numStr floatValue]]];
                    }
                    tempValueLabel.attributedText = string;
//                }
            }
        }
    }
}



@end
