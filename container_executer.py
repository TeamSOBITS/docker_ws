#!/usr/bin/env python
#coding:utf-8
#python2 or python3

import os
import subprocess
try:
    import Tkinter  # Python2
except ImportError: 
    import tkinter as Tkinter # Python3

class ContainerExecuter():
    def __init__(self):
        self.tk = Tkinter.Tk()
        self.running_containers_info = []       # 起動中のコンテナの一覧を格納する変数
        self.containers_info = []               # 全てのコンテナの一覧を格納する変数
        self.iconfile = Tkinter.PhotoImage(file=os.path.dirname(__file__)+'/img/icon.png')
        self.tk.call('wm', 'iconphoto', self.tk._w, self.iconfile)

    def create_gui(self):
        self.get_containers_info(is_running = False)
        self.get_containers_info(is_running = True)

        self.tk.title("ContainerExecuter")

        # GUI windowの大きさを定義する
        geometry_x = str(700)
        # コンテナがない場合にもGUIが表示されるようにする
        geometry_y = str(30*2) if len(self.containers_info)<2 else str(30*len(self.containers_info))
        # "window width x window height + position right + position down"
        self.tk.geometry(("%sx%s+0+0")%(geometry_x, geometry_y))
        # self.tk.iconbitmap(default=self.iconfile)
        
        for i, container_info in enumerate(self.containers_info):
            container_id = container_info[0]
            container_name = container_info[len(container_info)-1].replace(" ","")

            # コンテナが実行中なのかどうか確認する
            is_running = False
            for running_container_info in self.running_containers_info:
                if container_id == running_container_info[0]:
                    is_running = True
                    break
            
            # コンテナの実行中の場合は"restart"，"stop"，"exec"というボタンを表示させる
            if is_running:
                button = Tkinter.Button(self.tk, width=4, text="    ",    command=self.button_clicked_callback("dummy",   container_id)).place(x=100, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="restart", command=self.button_clicked_callback("restart", container_id)).place(x=160, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="stop",    command=self.button_clicked_callback("stop",    container_id)).place(x=220, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="exec",    command=self.button_clicked_callback("exec",    container_id)).place(x=280, y=i*30)

            else:
                button = Tkinter.Button(self.tk, width=4, text="start", command=self.button_clicked_callback("start", container_id)).place(x=100, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="    ",  command=self.button_clicked_callback("dummy", container_id)).place(x=160, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="    ",  command=self.button_clicked_callback("dummy", container_id)).place(x=220, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="    ",  command=self.button_clicked_callback("dummy", container_id)).place(x=280, y=i*30)

            label = Tkinter.Label(text=container_name, font=("",15)).place(x=340, y=i*30)

	    #GUI再起動用のボタンを定義
        btn = Tkinter.Button(self.tk, width=3, text="refresh", command=self.refresh_gui)
        btn.place(x=0, y=0)
        
        #GUI停止用のボタンを定義
        btn = Tkinter.Button(self.tk, width=3, text="close", command=self.quit_gui)
        btn.place(x=0, y=30)

        self.tk.mainloop()


    def button_clicked_callback(self, operation, container_id):
        def inner():
            if operation == "dummy":
                pass

            else:
                if operation == "exec":
                    print("[%s] container has been executed."%container_id)
                    cmd = "gnome-terminal -- bash -c 'docker exec -it --user sobits %s /bin/bash; bash'"%(container_id)
                
                elif operation == "start":
                    print("[%s] container has been started."%container_id)
                    cmd = "docker start %s "%(container_id)

                elif operation == "restart":
                    print("[%s] container has been restarted."%container_id)
                    cmd = "docker restart %s "%(container_id)
                
                elif operation == "stop":
                    print("[%s] container has been stopped."%container_id)
                    cmd = "docker stop %s "%(container_id)

                os.system(cmd) #回避策としてos.systemを使用
                self.refresh_gui()

        return inner 
    
    # [close]ボタンを押すと，GUIを終了させる
    def quit_gui(self):
        print("[close] button has been clicked.")
        self.tk.quit()
        self.tk.destroy()

    # [refresh]ボタンを押すと，GUIを再起動する
    def refresh_gui(self):
        print("[refresh] button has been clicked.")
        self.running_containers_info = []
        self.containers_info = []
        self.tk.quit()
        self.tk.destroy()
        self.__init__()
        self.create_gui()

    # コンテナの情報を登録する関数
    def get_containers_info(self, is_running=False):
        cmd = "docker ps" if is_running else "docker ps -a"
        res = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                               shell=True).communicate()[0]

        try:    #for python2
            containers_info = res.split("\n")
        except: #for python3
            res = res.decode()
            containers_info = res.split("\n")

        for i, container_info in enumerate(containers_info):
            # 配列の最初と最後の要素は余計なものが入るのでパス
            if i>0 and i<len(containers_info)-1:
                container_info = container_info.split("   ")
                
                # 空欄の要素を除去
                container_info =  [x for x in container_info if x]
                if is_running :  self.running_containers_info.append(container_info)
                else :           self.containers_info.append(container_info)
    

def main():
    ce = ContainerExecuter()
    ce.create_gui()

if __name__ == "__main__":
    main()