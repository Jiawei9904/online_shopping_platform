import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { Subject } from 'rxjs';
@Injectable({
  providedIn: 'root',
})
export class SharedService {
  private dataSource = new BehaviorSubject<any>(null);
  currentData = this.dataSource.asObservable();
  // make data trasfer from result-table to details
  public itemSelected: Subject<any> = new Subject();

  // 添加一个新的 BehaviorSubject 来管理活动按钮
  private activeButtonSource = new BehaviorSubject<'result' | 'wishlist'>(
    'result'
  ); // 默认为 'result'
  currentActiveButton = this.activeButtonSource.asObservable();

  constructor() {}

  updateData(data: any) {
    this.dataSource.next(data);
  }

  clearData() {
    this.dataSource.next(null);
  }

  // 添加一个新的方法来更新活动按钮状态
  updateActiveButton(buttonType: 'result' | 'wishlist') {
    this.activeButtonSource.next(buttonType);
  }
}
