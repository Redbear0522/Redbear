package board;

import java.sql.*;
import java.util.*;

public class GalleryDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private static GalleryDAO instance = new GalleryDAO();
	
	public static GalleryDAO getInstance() {
		return instance;
	}

	private GalleryDAO() {}
	
    private Connection connect() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			//String url = "jdbc:oracle:thin:@192.168.219.198:1521:orcl";
			String url = "jdbc:oracle:thin:@58.73.200.225:1521:orcl";
			

			conn = DriverManager.getConnection(url, "java03", "1234");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}

    private void disconnect() {
        try {
            if (rs != null && !rs.isClosed()) rs.close();
            if (pstmt != null && !pstmt.isClosed()) pstmt.close();
            if (conn != null && !conn.isClosed()) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int insertGallery(GalleryDTO gd) {
        int result = 0;
        int num = gd.getNum();
        int ref = gd.getRef();
        int re_step = gd.getRe_step();
        int re_level = gd.getRe_level();
        
        int number = 0;
        String sql = "";

        try {
            connect();
            sql = "select max(num) from gallery";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                number = rs.getInt(1) + 1;
            } else {
                number = 1;
            }
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();

            if (num != 0) { // 답글 처리
                sql = "update gallery set re_step=re_step+1 where ref=? and re_step > ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, ref);
                pstmt.setInt(2, re_step);
                pstmt.executeUpdate();
                if (pstmt != null) pstmt.close();

                re_step = re_step + 1;
                re_level = re_level + 1;
            
            } else { // 새 글 처리
                ref = number;
                re_step = 0;
                re_level = 0;
            }
            
            // [수정] filename, boardnum을 INSERT 쿼리에 추가
            sql = "insert into gallery(num, writer, title, content, pw, regdate, readcnt, ip, ref, re_step, re_level, filename, boardnum) "
                + "values(gallery_sq.nextval, ?, ?, ?, ?, sysdate, 0, ?, ?, ?, ?, ?, ?)";

            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, gd.getWriter());
            pstmt.setString(2, gd.getTitle());
            pstmt.setString(3, gd.getContent());
            pstmt.setString(4, gd.getPw());
            pstmt.setString(5, gd.getIp());
            pstmt.setInt(6, ref);
            pstmt.setInt(7, re_step);
            pstmt.setInt(8, re_level);
            pstmt.setString(9, gd.getFilename());   // [추가] filename
            pstmt.setInt(10, gd.getBoardnum());     // [추가] boardnum

            result = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return result;
    }

    public List<GalleryDTO> getGalleryList(int start, int end) {
        List<GalleryDTO> list = new ArrayList<>();
        // [수정] filename, boardnum을 SELECT 쿼리에 추가
        String sql = "select num,writer,title,pw,regdate,ref,re_step,re_level,content,ip,readcnt,filename,boardnum,r "
    			+ "from (select num,writer,title,pw,regdate,ref,re_step,re_level,content,ip,readcnt,filename,boardnum,rownum r "
    			+ "from (select num,writer,title,pw,regdate,ref,re_step,re_level,content,ip,readcnt,filename,boardnum "
    			+ "from gallery order by ref desc, re_step asc)) where r >= ? and r <= ?";
        try {
            connect();
            pstmt = conn.prepareStatement(sql);
    		pstmt.setInt(1, start);
    		pstmt.setInt(2, end);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                GalleryDTO dto = new GalleryDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setPw(rs.getString("pw"));
                dto.setRegdate(rs.getTimestamp("regdate")); 
                dto.setReadcnt(rs.getInt("readcnt"));
                dto.setRef(rs.getInt("ref"));
                dto.setRe_step(rs.getInt("re_step"));
    			dto.setRe_level(rs.getInt("re_level"));
    			dto.setContent(rs.getString("content"));
    			dto.setIp(rs.getString("ip"));
                dto.setFilename(rs.getString("filename"));   // [추가] filename
                dto.setBoardnum(rs.getInt("boardnum"));     // [추가] boardnum
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    public GalleryDTO getGallery(int num) {
        GalleryDTO dto = null;
        String updateSql = "UPDATE gallery SET readcnt = readcnt + 1 WHERE num = ?";
        String selectSql = "SELECT * FROM gallery WHERE num = ?";
        
        PreparedStatement pstmtUpdate = null;
        PreparedStatement pstmtSelect = null;

        try {
            conn = connect();
            
            pstmtUpdate = conn.prepareStatement(updateSql);
            pstmtUpdate.setInt(1, num);
            pstmtUpdate.executeUpdate();

            pstmtSelect = conn.prepareStatement(selectSql);
            pstmtSelect.setInt(1, num);
            rs = pstmtSelect.executeQuery();
            
            if (rs.next()) {
                dto = new GalleryDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setPw(rs.getString("pw"));
                dto.setRegdate(rs.getTimestamp("regdate"));
                dto.setReadcnt(rs.getInt("readcnt"));
                dto.setRef(rs.getInt("ref"));
                dto.setRe_step(rs.getInt("re_step"));
                dto.setRe_level(rs.getInt("re_level"));
                dto.setIp(rs.getString("ip")); // [추가] IP 정보 누락된 것 추가
                dto.setFilename(rs.getString("filename"));   // [추가] filename
                dto.setBoardnum(rs.getInt("boardnum"));     // [추가] boardnum
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	try {
                if (rs != null) rs.close();
                if (pstmtUpdate != null) pstmtUpdate.close();
                if (pstmtSelect != null) pstmtSelect.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            disconnect();
        }
        return dto;
    }

    public int updateGallery(GalleryDTO dto) {
        int res = 0;
        // [수정] filename을 UPDATE 쿼리에 추가
        String sql = "UPDATE gallery SET title = ?, content = ?, filename = ? WHERE num = ? AND pw = ?";
        try {
            connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setString(3, dto.getFilename()); // [추가] filename
            pstmt.setInt(4, dto.getNum());
            pstmt.setString(5, dto.getPw());
            res = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return res;
    }

    public int deleteGallery(int num, String pw) {
        int res = 0;
        String sql = "DELETE FROM gallery WHERE num = ? AND pw = ?";
        try {
            connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            pstmt.setString(2, pw);
            res = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return res;
    }
    
    public int getArticleCount() {
		int x = 0;
	 Connection local_conn = null;
    PreparedStatement local_pstmt = null;
    ResultSet local_rs = null;

		try {
			conn = connect();
			pstmt = conn.prepareStatement("select count(*) from gallery");
			rs = pstmt.executeQuery();
			if (rs.next()) {
				x = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return x;
	}
    public int getGalleryCount(int boardnum) {
		int result = 0;
		try {
			String sql = "select count(*) form gallery where boardnum=? ";			conn = connect();
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return result;
	}
    public List<GalleryDTO> getGalleryFile(int boardnum) {
        // [수정] 결과를 담을 List 객체 생성
        List<GalleryDTO> list = new ArrayList<>();
        
        // [수정] DB 관련 객체들을 모두 '지역 변수'로 선언하여 사용합니다. (안정성 향상)
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String sql = "select * from gallery where boardnum=?";
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardnum);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                GalleryDTO fileDTO = new GalleryDTO();
                fileDTO.setNum(rs.getInt("num"));
                fileDTO.setBoardnum(rs.getInt("boardnum"));
                fileDTO.setFilename(rs.getString("filename"));
                list.add(fileDTO);
                // [삭제] 목적에 맞지 않는 불필요한 코드 제거
                // result = rs.getInt(1); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // [수정] 사용한 지역 변수들을 직접 닫아줍니다.
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        // [수정] 메소드 선언에 맞게 List 객체를 반환합니다.
        return list;
    }
    
}
