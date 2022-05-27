#!/usr/bin/env python
#coding:utf-8
#python2 or python3
import sys, os
import subprocess
try: #for python2
    import Tkinter
except ImportError: #for python3
    import tkinter as Tkinter

class ContainerExecuter():
    def __init__(self):
        self.tk = Tkinter.Tk()
        self.tk.attributes("-topmost", True) #常に最前面表示
        self.running_containers_info = [] #起動中のコンテナの一覧を格納する変数
        self.containers_info = [] #全てのコンテナの一覧を格納する変数

    def create_gui(self):
        self.get_all_containers_info()
        self.get_runnning_containers_info()

        self.tk.title("ContainerExecuter")

        #GUI windowの大きさを定義
        geometry_x = str(700)
        if len(self.containers_info)<2: #コンテナがない場合にもGUIが表示されるようにする
            geometry_y = str(30*2)
        else: 
            geometry_y = str(30*len(self.containers_info))
        self.tk.geometry(("%sx%s+0+0")%(geometry_x, geometry_y)) # "window width x window height + position right + position down"
        
        for i, container_info in enumerate(self.containers_info):
            container_id = container_info[0]
            container_name = container_info[len(container_info)-1].replace(" ","")

            #conteiner_infoのコンテナがrun中かどうかチェック
            running_flag = False
            for running_container_info in self.running_containers_info:
                if container_id == running_container_info[0]:
                    running_flag = True
                    break
            
            #既にコンテナがrunしている場合は"restart", "stop"ボタン, "exec"ボタンを表示する
            if running_flag == True:
                button = Tkinter.Button(self.tk, width=4, text="    ", command=self.button_clicked_callback("dummy", container_id)).place(x=100, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="restart", command=self.button_clicked_callback("restart", container_id)).place(x=160, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="stop", command=self.button_clicked_callback("stop", container_id)).place(x=220, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="exec", command=self.button_clicked_callback("exec", container_id)).place(x=280, y=i*30)

            else:
                button = Tkinter.Button(self.tk, width=4, text="start", command=self.button_clicked_callback("start", container_id)).place(x=100, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="    ", command=self.button_clicked_callback("dummy", container_id)).place(x=160, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="    ", command=self.button_clicked_callback("dummy", container_id)).place(x=220, y=i*30)
                button = Tkinter.Button(self.tk, width=4, text="    ", command=self.button_clicked_callback("dummy", container_id)).place(x=280, y=i*30)

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
                    print("[%s] is executed."%container_id)
                    cmd = "gnome-terminal -- bash -c 'docker exec -it --user sobits %s /bin/bash; bash'"%(container_id)
                
                elif operation == "start":
                    print("[%s] is started."%container_id)
                    cmd = "docker start %s "%(container_id)

                elif operation == "restart":
                    print("[%s] is restarted."%container_id)
                    cmd = "docker restart %s "%(container_id)
                
                elif operation == "stop":
                    print("[%s] is stopped."%container_id)
                    cmd = "docker stop %s "%(container_id)

                os.system(cmd) #回避策としてos.systemを使用
                self.refresh_gui()

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
        self.containers_info = []
        self.tk.destroy()
        self.__init__()
        self.create_gui()

    def get_runnning_containers_info(self):
        #起動中のコンテナを返す関数
        res = subprocess.Popen(
          "docker ps", stdout=subprocess.PIPE,
          shell=True).communicate()[0]

        try: #for python2
            running_containers_info = res.split("\n")
        except: #for python3
            res = res.decode()
            running_containers_info = res.split("\n")

        for i, running_container_info in enumerate(running_containers_info):
            if i == 0 or i == len(running_containers_info)-1:
                #配列の０番目と最後の要素は余計なものが入るのでパス
                pass

            else:
                running_container_info = running_container_info.split("   ")
                running_container_info =  [x for x in running_container_info if x] #空欄の要素を除去
                self.running_containers_info.append(running_container_info)

    def get_all_containers_info(self):
        #全てのコンテナを返す関数
        res = subprocess.Popen(
          "docker ps -a", stdout=subprocess.PIPE,
          shell=True).communicate()[0]

        try: #for python2
            containers_info = res.split("\n")
        except: #for python3
            res = res.decode()
            containers_info = res.split("\n")

        for i, container_info in enumerate(containers_info):
            if i == 0 or i == len(containers_info)-1:
                #配列の０番目と最後の要素は余計なものが入るのでパス
                pass

            else:
                container_info = container_info.split("   ")
                container_info =  [x for x in container_info if x] #空欄の要素を除去
                self.containers_info.append(container_info)
    

    def main(self):
        self.create_gui()

if __name__ == "__main__":
    ce = ContainerExecuter()
    ce.main()
    #ce.get_all_containers_info()
    #ce.get_runnning_containers_info()
    #ce.get_not_running_containers_info()

    #print ce.not_running_containers_info