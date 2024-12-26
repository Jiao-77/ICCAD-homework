# ICCAD Homework2
## (Q2.1) Why did Ubuntu get such a name? Answer briefly along with your information source.
Ubuntu的名称源自南非的哲学概念“Ubuntu”，在祖鲁语和科萨语中意为“对他人的仁爱”或“我因为我们而存在”。这一理念强调人类之间的共享与联系，体现了Ubuntu操作系统所倡导的社区合作与自由软件精神。Ubuntu的创始人马克·沙特尔沃思（Mark Shuttleworth）来自南非，他选择这一名称以反映项目的南非根源和共享合作的理念。
## (Q2.2) According to the video Revolution OS, what application greatly motivated companies to use Linux instead of Windows? This information appears on which part of the video?
根据纪录片《操作系统革命》（Revolution OS），Apache HTTP服务器被认为是促使企业选择Linux而非Windows的重要应用程序之一。Apache是一个开源的Web服务器软件，因其高性能、稳定性和可定制性，广受企业欢迎。在影片中，Apache被描述为Linux的第一个“杀手级应用”（killer app），这意味着它是推动Linux广泛采用的关键因素之一。
## Write a shell script (must use vi) that displays the following menu and prompts for one-character input (i.e., '1' - '6' or 'q') to invoke a menu option, as shown.
### 选项一：
输出Hello World并配合第二项进行计数，因此第一项的脚本应为：
```bash
echo "Hello World"
((hello_count++))
```
### 选项二：
输出Hello World的打印次数，因此第二项的脚本应为：
```bash
echo "The script has printed Hello World! $hello_count times."
```
### 选项三：
寻找home内所有的文件并用长命令输出，但是含有以h开头的文件名的那一行要用黄色输出。
由于home目录中文件太多，在输出时不好展示，因此在展示时将目录改为本目录。
```bash
find . -type f -exec ls -l {} + | awk -F'/' '{if ($NF ~ /^h/) print "\033[1;33m"$0"\033[0m"; else print $0}'
```
- 首先使用`find`命令查找，使用`-type f`参数来确定避免目录文件，使用`-exec ls -l {} +`来用长命令输出找到的结果。
- 使用管道符`|`来将find的结构传到后面。
- 使用`awk`命令进行判断输出：
    - 使用`-F'/'`参数来根据`/`分割输出。
    - `$NF`：表示当前行的最后一个字段（也就是文件名）。
    - `~ /^h/`：表示匹配以 h 开头的文件名。
    - `"\033[1;33m"`：这是 ANSI 转义码，表示将后续文本设置为黄色，并加粗（1 表示加粗，33 表示黄色）。
    - `"$0"`：表示当前行的完整内容。
    - `"\033[0m"`：这是 ANSI 转义码，用于重置颜色，避免后续内容也被设置为黄色。
    - `else print $0`：如果文件名不以 h 开头，则直接打印该行内容，不作任何颜色修改。
### 选项四：
第四个选项的功能是输入一个文件名，检查该文件是否存在并且是可执行文件，然后以 **十六进制格式** 显示该文件的前 **16 字节** 内容。以下是具体的实现和代码解析：

```bash
read -p "Enter a file name: " filename
if [[ -x "$filename" && -f "$filename" ]]; then
    echo "First 16 bytes of $filename in hexadecimal:"
    head -c 16 "$filename" | od -t x1
else
    echo "File does not exist or is not executable."
fi
```

#### 1. **提示用户输入文件名**
```bash
read -p "Enter a file name: " filename
```
- 使用 `read` 命令提示用户输入文件名，并将其存储到变量 `filename` 中。

---

#### 2. **检查文件是否存在且为可执行文件**
```bash
if [[ -x "$filename" && -f "$filename" ]]; then
```
- `-x "$filename"`：检查文件是否是 **可执行文件**。
- `-f "$filename"`：检查文件是否是 **普通文件**（不是目录或设备文件）。
- 逻辑条件 `&&` 表示文件必须同时满足两个条件。

如果文件存在且是可执行文件，则继续显示文件内容；否则执行 `else` 块，打印错误消息。

---

#### 3. **显示文件的前 16 字节内容**
```bash
head -c 16 "$filename" | od -t x1
```
- `head -c 16 "$filename"`：
  - 使用 `head` 命令读取文件的前 16 个字节。
  - `-c 16` 表示按字节数读取文件的前 16 个字节。

- `| od -t x1`：
  - 将 `head` 的输出通过管道传递给 `od` 命令。
  - `od` 是一个二进制查看工具，`-t x1` 表示以 **十六进制格式** 显示每个字节。

例如：
如果文件前 16 个字节是 `Hello World!`, 则输出可能是：
```
0000000 48 65 6c 6c 6f 20 57 6f 72 6c 64 21
```
每个值是一个字节的十六进制表示。

---

#### 4. **文件不存在或不可执行**
```bash
else
    echo "File does not exist or is not executable."
fi
```
- 如果文件不存在或不是可执行文件，则打印一条错误消息。

### 选项五
第五个选项的功能是：
- 输入一个文件名，检查该文件是否存在且为可执行文件。
- 如果满足条件，读取该文件的 **前 16 个字节的十六进制头部信息**。
- 然后在同一目录中搜索与该文件有相同头部信息的所有其他文件，并列出这些文件。

```bash
read -p "Enter a file name: " filename
if [[ -x "$filename" && -f "$filename" ]]; then
    header=$(head -c 16 "$filename" | od -t x1 | awk '{print $2 $3 $4 $5 $6 $7 $8 $9}')
    dir=$(dirname "$filename")
    echo "Files in the same directory with the same 16 bytes header:"
    for file in "$dir"/*; do
        if [[ -f "$file" && -x "$file" ]]; then
            file_header=$(head -c 16 "$file" | od -t x1 | awk '{print $2 $3 $4 $5 $6 $7 $8 $9}')
            if [[ "$file_header" == "$header" ]]; then
                echo "$file"
            fi
        fi
    done
else
    echo "File does not exist or is not executable."
fi
```

#### 1. **提示用户输入文件名**
```bash
read -p "Enter a file name: " filename
```
- 使用 `read` 命令提示用户输入一个文件名，并将其存储到变量 `filename` 中。

---

#### 2. **检查文件是否存在且为可执行文件**
```bash
if [[ -x "$filename" && -f "$filename" ]]; then
```
- `-x "$filename"`：检查文件是否是 **可执行文件**。
- `-f "$filename"`：检查文件是否是 **普通文件**。
- 如果满足条件，进入 `if` 块；否则，执行 `else` 块，打印错误消息。

---

#### 3. **提取该文件的前 16 字节的十六进制头部**
```bash
header=$(head -c 16 "$filename" | od -t x1 | awk '{print $2 $3 $4 $5 $6 $7 $8 $9}')
```
- `head -c 16 "$filename"`：从文件中读取前 16 个字节。
- `| od -t x1`：将读取到的字节转换为十六进制格式。
- `| awk '{print $2 $3 $4 $5 $6 $7 $8 $9}'`：
  - 提取十六进制输出的第 2 至第 9 列（文件头部信息）。
  - 例如，如果前 16 字节是：
    ```
    0000000 48 65 6c 6c 6f 20 57 6f 72 6c 64 21
    ```
    `awk` 提取的结果为：`48656c6c6f20576f`.

---

#### 4. **获取文件所在目录**
```bash
dir=$(dirname "$filename")
```
- `dirname` 是一个命令，用于提取文件路径中的目录部分。
- 如果文件路径为 `/home/user/file.txt`，则 `dirname` 返回 `/home/user`。

---

#### 5. **在同一目录中查找文件**
```bash
for file in "$dir"/*; do
```
- 遍历当前目录下的所有文件，检查每个文件的头部信息。

---

#### 6. **检查文件是否存在且为可执行文件**
```bash
if [[ -f "$file" && -x "$file" ]]; then
```
- `-f "$file"`：文件是否为普通文件。
- `-x "$file"`：文件是否可执行。

---

#### 7. **提取当前文件的头部信息**
```bash
file_header=$(head -c 16 "$file" | od -t x1 | awk '{print $2 $3 $4 $5 $6 $7 $8 $9}')
```
- 读取当前文件的前 16 字节并转换为十六进制，与目标文件的头部信息进行对比。

---

#### 8. **比较文件头部信息**
```bash
if [[ "$file_header" == "$header" ]]; then
    echo "$file"
fi
```
- 如果当前文件的头部信息与目标文件的头部信息相同，则打印文件路径。

---

#### 9. **文件不存在或不可执行**
```bash
else
    echo "File does not exist or is not executable."
fi
```
- 如果用户输入的文件不符合条件，打印错误消息。

---
=== 选项六：
第六个选项的功能是：

- 使用 `/usr/bin/ftp` 访问远程 FTP 服务器 `alpha.gnu.org`。
- 在服务器的 `/gnu` 目录中，查找 **自 2005 年以来未修改过** 的目录。
- 输出这些未修改过的目录名称。
```bash
echo "Checking '/gnu' directories that have not changed after 2005:"
/usr/bin/ftp -n << EOF > ftp_output.txt
open alpha.gnu.org
user anonymous anonymous@example.com
cd /gnu
ls
quit
EOF

echo "Directories not changed since 2005:"
awk '{if ($8 < 2005 && $8 ~ /^[0-9]{4}/) print $NF}' ftp_output.txt

```


#### 1. **使用 `/usr/bin/ftp`**
`/usr/bin/ftp` 是一个命令行 FTP 客户端，用于与 FTP 服务器交互。它支持自动化脚本，常用于文件传输、目录操作等。

#### 2. **进入 FTP 非交互模式**
```bash
/usr/bin/ftp -n << EOF
...
EOF
```
- `-n` 参数：表示非交互模式，禁用自动登录。因为alpha.gnu.org只接受匿名登录，使用ftp的config登录会导致后续命令无法完成。
- `<< EOF ... EOF`：定义了一个 **Here Document**，将 `EOF` 和 `quit` 之间的内容作为 FTP 客户端的指令。

#### 3. **连接到 FTP 服务器**
```bash
open alpha.gnu.org
```
- `open alpha.gnu.org`：连接到远程 FTP 服务器 `alpha.gnu.org`。
#### 4. **匿名登录到服务器**
```bash
user anonymous anonymous@example.com
```
- 使用匿名身份登录来进行后续步骤。

#### 5. **进入 `/gnu` 目录**
```bash
cd /gnu
```
- `cd /gnu`：切换到服务器上的 `/gnu` 目录。

#### 6. **列出目录内容**
```bash
ls
```
- `ls`：列出 `/gnu` 目录下的文件和子目录。
- FTP 的 `ls` 命令类似于 Unix 系统的 `ls`，输出每个文件/目录的名称和详细信息，包括权限、所有者、大小和最后修改日期。

#### 7. **退出 FTP 会话**
```bash
quit
```
- `quit`：退出 FTP 会话。

#### 8. **判断输出**
用 `awk` 提取年份并判断是否早于 2005 年：
   ```bash
   awk '{if ($8 < 2005 && $8 ~ /^[0-9]{4}/) print $NF}' ftp_output.txt
   ```

   - `$8`：表示第六列（年份）。
   - `$8 ~ /^[0-9]{4}$/`：确保第六列是一个四位数字（年份）。
   - `$8 < 2005`：判断年份是否早于 2005 年。
   - `$NF`：输出最后一列（目录名）。

## Find "demo_inout.c" from our demo bundle, try to build by "gcc -o demo_inout demo_inout.c", run the resulted executable "demo_inout". Then, let demo_inout read some text input from a file, and in the same time, send two outputs (i.e., stdout & stderr ) to other two separate files. By doing so, figure out the mechanism of stdin, stdout and stderr re-directions.

### **步骤 1：查找并编译 `demo_inout.c`**


```bash
gcc -o demo_inout demo_inout.c
```
如果编译成功，将生成可执行文件 `demo_inout`。

---

### **步骤 2：运行 `demo_inout`**

运行程序，观察其行为：

```bash
./demo_inout
```
### **步骤 3：创建输入文件**

为了让程序从文件读取输入，先创建一个输入文件`input.txt`：

Tidwdadwadwadwadwadwadwasdwas aadwadwdwasdwa

- 文件 `input.txt` 中的内容将作为程序的标准输入（`stdin`）。

---

### **步骤 4：重定向输入和输出**

在运行程序时，可以使用以下命令同时完成：
1. 将 `input.txt` 作为 **标准输入**（`stdin`）。
2. 将 **标准输出**（`stdout`）重定向到文件 `stdout.txt`。
3. 将 **标准错误**（`stderr`）重定向到文件 `stderr.txt`。

```bash
./demo_inout < input.txt > stdout.txt 2> stderr.txt
```

#### **命令解释**：
- `< input.txt`：将文件 `input.txt` 的内容作为程序的标准输入。
- `> stdout.txt`：将程序的标准输出（`stdout`）写入文件 `stdout.txt`。
- `2> stderr.txt`：将程序的标准错误输出（`stderr`）写入文件 `stderr.txt`。

### **步骤 5：检查输出**：
- `cat stdout.txt`：
    ready to get inputs from stdin.
    to stdout Tidwdadwadwadwadwadwadwasdwas
- `cat stderr.txt`:
    to stderr aadwadwdwasdwa
### 总结：
- 输入流（stdin）：

    - 通过 < input.txt 重定向，程序从文件中读取数据，而非直接从键盘输入。
- 输出流（stdout 和 stderr）：

    - 程序的正常输出（如提示信息和第一个字符串）被重定向到 stdout.txt。
    - 程序的错误输出（如第二个字符串）被重定向到 stderr.txt。
- stdin、stdout 和 stderr 的用途分工：

    - stdin：提供程序输入。
    - stdout：输出程序正常行为的信息。
    - stderr：输出程序的错误或警告信息。
通过重定向，我们可以将输入和输出分别保存到文件中，避免混乱，并实现更好的日志管理和调试功能。

## (P2.3) Write a shell script 'pingsort' (must use vi) that takes a whole list of host names as command line arguments. The script pings each host 5 times and reports the average responding time of each host in the order of the delays (unreachable addresses are sorted by their IP addresses).
编写一个名为 `pingsort` 的 shell 脚本，该脚本可以接收一组主机名作为命令行参数，功能如下：

1. **逐一对主机名进行 ping 测试**：
   - 对每个主机 `ping` 5 次，统计平均响应时间。
   - 如果主机无法访问，标记为不可到达（`unreachable`）。

2. **输出主机信息和排序结果**：
   - 对可达的主机，根据平均响应时间从小到大排序输出。
   - 对不可达的主机，根据其 IP 地址（升序）排序输出。

3. **输入支持无限数量的主机名**：
   - 脚本需要动态处理命令行参数，可以接收任意数量的主机名，而不仅仅是 5 个。

### **解决思路**

1. **提取 IP 地址和响应时间**：
   - 使用 `ping` 命令获取平均响应时间和 IP 地址：
     - `ping -c 5`：表示发送 5 个 ICMP 请求。
     - 使用 `awk` 或 `grep` 提取结果中的 IP 地址和平均时间。

2. **处理不可达的主机**：
   - 如果 `ping` 失败，输出该主机为不可达（`unreachable`），并提取其 IP 地址。

3. **数据存储和排序**：
   - 将所有主机信息存储到数组中。
   - 对可达的主机按响应时间排序。
   - 对不可达的主机按 IP 地址排序。

4. **输出格式化结果**：
   - 按格式输出所有主机的结果，分为可达和不可达两部分。


### **脚本实现**

使用 `vi` 创建脚本文件 `pingsort`：

```bash
#!/bin/bash

reachable=()
unreachable=()

for host in "$@"; do
        result=$(ping -c 5 -W 1 "$host" 2>/dev/null$)

        if echo "$result" | grep -q "rtt min/avg/max/mdev"; then
                ip=$(echo "$result" | head -1 | awk -F'[()]' '{print $2}')
                avg_time=$(echo "$result" | tail -1 | awk -F'/' '{print $5}')
                reachable+=("$host @ $ip @ $avg_time ms")
        else
                ip=$(nslookup "$host" 2>/dev/null | grep 'Address:' | tail -n 1 | awk '{print $2}')
                [[ -z "$ip" ]] && ip="UNKNOWN"
                unreachable+=("$host @ $ip is unreachable")
        fi
done

reachable_sorted=$(printf "%s\n" "${reachable[@]}" | sort -t '@' -k3 -n)
ubreachable_sorted=$(printf "%s\n" "${unreachable[@]}" |sort -t '@' -k2)

echo "$reachable_sorted"
echo "$ubreachable_sorted"

```

---

### **脚本运行步骤**

#### 1. **创建脚本文件**
使用 `vi` 编辑器创建脚本文件：
```bash
vi pingsort
```
按 `i` 进入插入模式，将上述代码粘贴到文件中。

#### 2. **保存并退出**
按 `Esc`，输入 `:wq` 保存并退出。

#### 3. **赋予执行权限**
```bash
chmod +x pingsort
```

#### 4. **运行脚本**
输入一组主机名运行脚本，例如：
```bash
./pingsort www.zju.edu.cn www.google.com www.cnn.com wikipedia.org www.sina.com.cn
```


#### **输出结果**：

1. 可达主机：
```
www.zju.edu.cn @ 240e:f7:e700:1fb:3::3d9 @ 60.819 ms
www.sina.com.cn @ 240e:f7:c010:119:3::3f4 @ 65.132 ms
www.cnn.com @ 2a04:4e42:8c::773 @ 174.687 ms
```

2. 不可达主机：
```
www.google.com @ 93.46.8.89 is unreachable
wikipedia.org @ 198.34.26.96 is unreachable
```

---

### **重点功能分析**

1. **动态参数支持**
   - 使用 `$@` 处理输入的所有参数，支持任意数量的主机名。

2. **IP 地址解析**
   - 对于成功的 `ping`，从首行提取 IP 地址。
   - 对于失败的主机，使用 `nslookup` 提取 IP 地址。

3. **排序逻辑**
   - 对可达主机，按平均响应时间排序。
   - 对不可达主机，按 IP 地址排序（`UNKNOWN` 会排在最前）。

4. **结果格式化**
   - 输出分为两部分：可达主机和不可达主机，分别显示详细信息。

5. **超时设置**
   - 使用 `-W` 参数为 `ping` 设置超时时间：
     ```bash
     ping -c 5 -W 1 "$host"
     ```
## (P2.4) (OPTIONAL)Read manuals for command "wget" and command "cron". With the help of these commands and other utilities we have learned, try to write some shell programs which can be used to automatically visit www.bing.com every noon to download a background image to your local computer. Explain the flow first. Then, read manual of command ˇ°gsettingsˇ±, and find how to use this image as your desktop background picture.
### **任务分解**

本任务分为以下几个步骤：

1. **理解需求**：
   - 每天中午自动访问 `www.bing.com`，下载背景图片到本地。
   - 将下载的图片设置为桌面背景。

2. **实现流程**：
   - 使用 `wget` 命令从 `www.bing.com` 下载背景图片。
   - 使用 `cron` 定时任务实现每天中午自动运行脚本。
   - 使用 `gsettings` 命令将下载的图片设置为桌面背景。

---

### **实现流程**

#### **第一步：访问 `www.bing.com` 并下载图片**

1. **访问 `www.bing.com`**
   - Bing 的主页通常包含背景图片的链接，图片信息可通过以下 URL 获取：
     ```
     https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US
     ```
   - 这个 JSON 文件包含当天背景图片的下载链接。

2. **提取图片链接并下载**
   使用以下命令提取图片链接并下载图片：
   ```bash
   wget -q -O - "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US" | \
   grep -oP '"url":"\K[^"]+' | \
   sed 's/^/https:\/\/www.bing.com/' | \
   xargs wget -q -O ~/Pictures/bing_background.jpg
   ```

   **命令解释**：
   - `wget -q -O -`：访问 Bing 的 JSON 文件并输出到标准输出。
   - `grep -oP '"url":"\K[^"]+'`：用正则表达式提取图片链接部分。
   - `sed 's/^/https:\/\/www.bing.com/'`：将相对路径补全为完整 URL。
   - `xargs wget -q -O ~/Pictures/bing_background.jpg`：下载图片到本地 `~/bing_background.jpg`。

---

#### **第二步：设置定时任务**

使用 `cron` 定时任务每天中午执行脚本：

1. **编辑 `cron` 定时任务**
   - 打开 `crontab` 编辑器：
     ```bash
     crontab -e
     ```

2. **添加任务**
   - 在 `crontab` 文件中添加以下任务：
     ```bash
     0 12 * * * /bin/bash ~/download_bing_image.sh
     ```

   **格式说明**：
   - `0 12 * * *`：表示每天中午 12:00 运行任务。
   - `/bin/bash ~/download_bing_image.sh`：运行下载脚本。

---

#### **第三步：设置桌面背景**

1. **编写脚本**
   在 `~/download_bing_image.sh` 中添加以下内容：

   ```bash
   #!/bin/bash

   wget -q -O - "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US" | \
   grep -oP '"url":"\K[^"]+' | \
   sed 's/^/https:\/\/www.bing.com/' | \
   xargs wget -q -O ~/Pictures/bing_background.jpg

   gsettings set org.gnome.desktop.background picture-uri "file:///$HOME/Pictures/bing_background.jpg"
   gsettings set org.gnome.desktop.background picture-options "zoom"
   ```

2. **赋予脚本执行权限**
   ```bash
   chmod +x ~/download_bing_image.sh
   ```

3. **脚本内容说明**
   - `gsettings set org.gnome.desktop.background picture-uri`：设置桌面背景图片路径。
   - `gsettings set org.gnome.desktop.background picture-options "zoom"`：设置背景图片显示模式为缩放（`zoom`）。

---

### **流程总结**

1. **核心工具**：
   - `wget`：从 Bing 网站获取背景图片。
   - `cron`：每天中午自动运行脚本。
   - `gsettings`：设置桌面背景。

2. **工作流程**：
   - 每天中午 12:00，`cron` 定时任务触发 `~/download_bing_image.sh` 脚本。
   - 脚本使用 `wget` 从 Bing 下载背景图片，并保存为 `~/bing_background.jpg`。
   - 使用 `gsettings` 命令将下载的图片设置为桌面背景。

3. **最终效果**：
   - Bing 的每日背景图片会自动下载并设置为桌面背景，无需手动操作。
