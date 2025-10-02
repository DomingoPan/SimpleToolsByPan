import os
from moviepy.editor import VideoFileClip
import imageio

# === 設定區 ===
input_folder = "C:/Users/ADMIN/Videos"   # 輸入資料夾
output_folder = input_folder             # 輸出資料夾（可改）
target_duration = 6                  # GIF 播放時長（秒）
resize_height = 360                      # 壓縮解析度高度，例如 360p，若不要縮放則設為 None
max_fps = 10                             # 限制最大 FPS，避免過大 GIF

# === 顯示影片基本資訊 ===
for filename in os.listdir(input_folder):
    if filename.lower().endswith(".mp4"):
        path = os.path.join(input_folder, filename)
        clip = VideoFileClip(path)
        print(f"{filename} - 幀率: {clip.fps:.2f} fps，畫面數: {clip.reader.nframes}，時長: {clip.duration:.2f} 秒")
        clip.close()

print("\n開始製作 GIF...\n")

# === GIF 轉檔流程 ===
for filename in os.listdir(input_folder):
    if filename.lower().endswith(".mp4"):
        mp4_path = os.path.join(input_folder, filename)
        gif_filename = os.path.splitext(filename)[0] + ".gif"
        gif_path = os.path.join(output_folder, gif_filename)

        print(f"處理中：{filename} ...")
        clip = VideoFileClip(mp4_path)
        
        # 可選：調整解析度
        if resize_height is not None:
            clip = clip.resize(height=resize_height)

        original_duration = clip.duration
        frame_count = int(clip.fps * original_duration)
        target_fps = min(frame_count / target_duration, max_fps)

        print(f"→ 原時長: {original_duration:.2f}s，共 {frame_count} 幀 → 目標 FPS: {target_fps:.2f}，解析度: {clip.size}")

        # 取出幀
        frames = [frame for frame in clip.iter_frames()]
        clip.close()

        # 儲存 GIF
        imageio.mimsave(gif_path, frames, fps=target_fps, loop=0) #loop調整循環次數，0為無線循環

        print(f"完成：{gif_filename}")

print("\n✅ 所有 MP4 影片已轉換完成。")
