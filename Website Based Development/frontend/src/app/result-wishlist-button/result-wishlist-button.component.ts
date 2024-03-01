import { Component } from '@angular/core';
import { SharedService } from '../services/shared.service'; // 确保路径正确
import { EventEmitter, Output, Input, SimpleChanges } from '@angular/core';
@Component({
  selector: 'app-result-wishlist-button',
  templateUrl: './result-wishlist-button.component.html',
  styleUrls: ['./result-wishlist-button.component.css'],
})
export class ResultWishlistButtonComponent {
  // 定义一个属性来跟踪激活的按钮
  activeButton: 'result' | 'wishlist' = 'result';
  @Output() wishlistClicked = new EventEmitter<void>(); // go to wishlist
  @Output() resultsClicked = new EventEmitter<void>();
  @Input() active!: 'result' | 'wishlist'; // 接收外部的激活状态
  constructor(private sharedService: SharedService) {}

  ngOnChanges(changes: SimpleChanges) {
    if (changes['active'] && this.active) {
      this.toggleButton(this.active);
    }
  }

  toggleButton(buttonType: 'result' | 'wishlist') {
    this.activeButton = buttonType;
    // 当按钮切换时，更新服务中的状态
    this.sharedService.updateActiveButton(buttonType);
    if (buttonType === 'wishlist') {
      this.wishlistClicked.emit();
    } else if (buttonType === 'result') {
      this.resultsClicked.emit();
    }
  }
}
