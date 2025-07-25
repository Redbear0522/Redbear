package board;

import java.sql.Date;

public class GalleryDTO {
    private int num;
    private String writer;
    private String title;
    private String content;
    private String pw;
    private String regdate;
    private String moddate;      // 수정일 추가
    private int readcnt;
    private String ip;
    private int ref;
    private int re_step;
    private int re_level;
    private String image;

    public String getImage() {   // ↖ 추가
        return image;
    }
    public void setImage(String image) {
        this.image = image;
    }
    public String getModdate() {
    return moddate;
	}
	public void setModdate(String moddate) {
		this.moddate = moddate;
	}
    
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	public int getReadcnt() {
		return readcnt;
	}
	public void setReadcnt(int readcnt) {
		this.readcnt = readcnt;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public int getRef() {
		return ref;
	}
	public void setRef(int ref) {
		this.ref = ref;
	}
	public int getRe_step() {
		return re_step;
	}
	public void setRe_step(int re_step) {
		this.re_step = re_step;
	}
	public int getRe_level() {
		return re_level;
	}
	public void setRe_level(int re_level) {
		this.re_level = re_level;
	}
    
}
