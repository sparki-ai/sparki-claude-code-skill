# Claude Code 官方目录提交材料

> 用途：照此填写 **Console 提交表单**（个人作者路径，无需公司主体）。
> 表单入口：**https://platform.claude.com/plugins/submit**
> 前提：用你的个人 Claude 账号登录即可，无需 Team/Enterprise 组织。
> 备用（有公司组织时）：https://claude.ai/admin-settings/directory/submissions/plugins/new

---

## 提交前状态确认（已全部就绪 ✅）

- 仓库：**https://github.com/fischerlam/sparki-claude-code-skill**（PUBLIC）
- 分支：`main` · 提交前以远端最新 commit 为准
- `claude plugin validate` → ✔ 通过（审核流水线跑的是同一个校验）
- plugin.json version `1.1.4`，与 SKILL.md 一致（版本不一致是最常见的拒绝原因，已避开）

> ⚠️ 提交前若又推了新 commit，审核会 pin 到最新 SHA；确保推之后再校验一次。

---

## 表单逐栏填写建议

### 1. Repository URL
```
https://github.com/fischerlam/sparki-claude-code-skill
```
> 提交的是仓库地址，不是某个子目录。审核会自动读取其中的 `.claude-plugin/plugin.json`。

### 2. Plugin name
```
sparki-video-editor
```
> 与 plugin.json 的 `name` 一致。用户调用时是 `/sparki-video-editor:...`。

### 3. Short description（一句话，列表页展示）
```
AI video editor — turn raw footage into vlogs, highlight reels, and social clips (TikTok/Shorts/Reels) by just describing the edit. Cloud-rendered, no ffmpeg.
```

### 4. Category（选最贴近的）
建议：**Creative / Media / Content**（表单给什么选项就挑最接近的创意/媒体类）

### 5. Long description（详情页，可用下面这段）
```
Sparki turns raw footage into polished, ready-to-post video without any editing
experience. Point Claude at a local video and describe what you want — "make a
vertical travel vlog with captions" — and Sparki uploads it, edits it in the
cloud, and saves the finished file to your working directory.

Three ways to edit:
• Style-guided — pick a preset (vlog, highlight reel, AI captions, and more)
• Prompt-driven — describe the edit in plain language
• Style-clone — replicate a reference video's editing style

All rendering runs on the cloud-hosted Sparki API — no ffmpeg, no local
rendering. First-time setup connects an existing Sparki account in the browser.
```

### 6. Example prompts（表单常会要 starter prompts）
```
- Edit ./raw/trip.mp4 into a vertical travel highlight reel with captions
- Turn these clips into a 60-second TikTok montage with energetic pacing
- Add AI captions to ./interview.mp4 and translate them to English
```

### 7. Setup / prerequisites（如有此栏）
```
1. Install the engine: uv tool install --upgrade sparki-cli  (requires uv)
2. Run `sparki config-status --channel claude`.
3. If not configured, run `sparki login --channel claude` and approve in the browser.
4. Run `sparki doctor --channel claude` to confirm setup.
```

### 8. Author / Publisher identity
- 以**个人作者**身份填写（表单会要求 **individual verification** 个人实名，不需要公司注册信息）
- Author 显示名建议：你本人的名字，或 `Sparki`
- Homepage：`https://sparki.io`
- Support：`support@sparki.io`

### 9. License
```
MIT-0
```

---

## 提交后会发生什么

1. 审核流水线跑 `claude plugin validate` + 自动安全扫描（恶意代码 / 凭证窃取模式等）。
2. 通过后 pin 到当前 commit SHA，进入 `anthropics/claude-plugins-community` 目录。
3. 公开目录**每晚同步**，审核通过到实际可见有延迟。
4. 想确认是否已上架：在下面这个 catalog 里搜 `sparki-video-editor`
   https://github.com/anthropics/claude-plugins-community/blob/main/.claude-plugin/marketplace.json

> 注：`claude-plugins-official`（官方精选）是 Anthropic 自行决定收录的，**没有申请入口**，这个表单只进 community 目录。

---

## 身份验证提示（个人作者）

表单提交前需完成 **individual verification**（个人身份验证），审核方会核对提交材料与发布者一致。准备好个人身份信息即可。这一步只能你本人在登录态下完成。
