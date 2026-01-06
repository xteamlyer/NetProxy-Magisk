

## 版本4.0.5（2026-01-06）

### 🧩 WebUI 与前端结构调整
* 全新的状态页设计（参考 flclash）
* 重构 WebUI 服务层，按领域拆分为模块化结构
* 移除新年特效相关代码
* 调整顶部标题显示位置，移除顶部主题切换功能
* 原“配置页”更名为“节点”，并更换图标
* `uid-page.js` 重命名为 `app-page.js`
* `i18n-service.js` 移入 `src/i18n/`
* `monet.css` 移入 `styles/` 目录，移除 `style.css`
* 删除 `status-card.css`

---

### 核心脚本与服务体系

* 使用统一的 `service.sh` 替代旧的 `start.sh / stop.sh`
* 合并启动与停止逻辑，支持：

  * `start / stop / restart / status`
  * `status` 显示 PID 与运行时间
* `ksu-service.js` 统一调用新 `service.sh`
* 服务日志同时输出到文件与 `stderr`
* 修复 `log()` 输出到 stdout 导致命令替换捕获日志的问题

---

### 网络、代理与规则能力

* 实现 **出站模式切换**
* 优化 TProxy 脚本性能，减少外部进程调用
* 内置 **秋风广告规则 v1.6.9**
* 修改部分配置文件，尝试修复 DNS / 订阅相关问题

---

### 安装与设备兼容性

* 全新的安装脚本
* 优化 OnePlus A16 修复脚本与服务启动逻辑

---
