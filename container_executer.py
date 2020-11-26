#!/usr/bin/env python
#coding:utf-8
#python2.7 or python3.5
import sys, os
import subprocess
try: #for python2.7
    import Tkinter
except ImportError: #for python3.5
    import tkinter as Tkinter

class ContainerExecuter():
    def __init__(self):
        self.tk = Tkinter.Tk()
        self.tk.attributes("-topmost", True) #常に最前面表示
        self.running_containers_info = []

    def create_gui(self):
        self.get_runnning_containers_info()

        self.tk.title("ContainerExecuter")

        if len(self.running_containers_info) == 0:
            print("No containers are running.")
            self.tk.geometry("500x30")
        
        else:
            for i, running_container_info in enumerate(self.running_containers_info):
                container_id = running_container_info[0]
                container_name = running_container_info[len(running_container_info)-1]

                btn = Tkinter.Button(self.tk, text=container_name, command=self.button_clicked_callback(container_id))
                btn.pack()

            geometry_x = str(500)
            geometry_y = str(30*len(self.running_containers_info))
            self.tk.geometry(("%sx%s")%(geometry_x, geometry_y))

	#GUI再起動用のボタンを定義
        btn = Tkinter.Button(self.tk, text="refresh", command=self.refresh_gui)
        btn.place(x=0, y=0)
        
        #GUI停止用のボタンを定義
        btn = Tkinter.Button(self.tk, text="close", command=self.quit_gui)
        btn.place(x=0, y=30)

        self.tk.mainloop()

    def button_clicked_callback(self, container_id):
        def inner():
            print("[%s] is executed."%container_id)
            exec_container_cmd = "gnome-terminal -- bash -c 'docker exec -it --user sobits %s /bin/bash; bash'"%(container_id)
            #subprocess.call(exec_cmd.split(" "), shell=True) #subprocessだとgnome-terminalの起動がうまく行かない・・・
            os.system(exec_container_cmd) #回避策としてos.systemを使用
        return inner 
    
    def quit_gui(self):
        # "close"ボタンを押すと、GUIを終了させる
        print("[close] button is clicked.")
        self.tk.quit()
        self.tk.destroy()
    
    def refresh_gui(self):
        # "refresh"ボタンを押すと、GUIを再起動する
        print("[refresh] button is clicked.")
        self.running_containers_info = []
        self.tk.destroy()
        self.__init__()
        self.create_gui()

    def get_runnning_containers_info(self):
        #起動中のコンテナを返す関数
        res = subprocess.Popen(
          "docker ps", stdout=subprocess.PIPE,
          shell=True).communicate()[0]

        running_containers_info = res.split("\n")

        for i, running_container_info in enumerate(running_containers_info):
            if i == 0 or i == len(running_containers_info)-1:
                #配列の０番目と最後の要素は余計なものが入るのでパス
                pass

            else:
                running_container_info = running_container_info.split("   ")
                running_container_info =  [x for x in running_container_info if x] #空欄の要素を除去
                self.running_containers_info.append(running_container_info)

    def main(self):
        self.create_gui()

if __name__ == "__main__":
    ce = ContainerExecuter()
    ce.main()
