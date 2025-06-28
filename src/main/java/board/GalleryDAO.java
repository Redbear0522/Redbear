package board;

import java.sql.*;
import java.time.LocalDate;
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

    // GallerygreSQL 연결 메서드
    private Connection connect() {
        try {
            Class.forName("org.postgresql.Driver");
            String url = 
                "jdbc:postgresql://"
              + "dpg-d1egnpje5dus73bdibt0-a.singapore-postgres.render.com"
              + ":5432/redbearstorage?sslmode=require";
            String user = "redbearstorage_user";
            String pass = "3MIkZPNJS880iE9NhM0f5s73EQ3MbcFQ";
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 리소스 해제
    private void disconnect() {
        try { if (rs    != null) rs.close();    } catch (SQLException ignored) {}
        try { if (pstmt != null) pstmt.close(); } catch (SQLException ignored) {}
        try { if (conn  != null) conn.close();  } catch (SQLException ignored) {}
    }

    /** 1. 글 등록 */
    public int insertGallery(GalleryDTO pd) {
        int result = 0;
        int num      = pd.getNum();
        int ref      = pd.getRef();
        int re_step  = pd.getRe_step();
        int re_level = pd.getRe_level();
        int number   = 0;

        try {
            conn = connect();
            // 최대 num 조회
            String maxSql = "SELECT COALESCE(MAX(num),0) FROM Gallery";
            pstmt = conn.prepareStatement(maxSql);
            rs = pstmt.executeQuery();
            if (rs.next()) number = rs.getInt(1) + 1;
            rs.close(); pstmt.close();

            // 답글 처리
            if (num != 0) {
                String uSql = "UPDATE Gallery SET re_step = re_step + 1 WHERE ref = ? AND re_step > ?";
                pstmt = conn.prepareStatement(uSql);
                pstmt.setInt(1, ref);
                pstmt.setInt(2, re_step);
                pstmt.executeUpdate();
                pstmt.close();
                re_step++; re_level++;
            } else {
                ref = number; re_step = 0; re_level = 0;
            }

            // INSERT: regdate, readcnt는 테이블 기본값 사용, 컬럼에서 제거
            String iSql =
            	     "INSERT INTO Gallery(" +
            	     " num,writer,title,content,pw,ip,ref,re_step,re_level,image" +    // image 칼럼 추가
            	     ") VALUES (" +
            	     " nextval('Gallery_sq'), ?,?,?,?,?,?,?,?,?" +                       // 물음표 하나 늘림
            	     ")";
            pstmt = conn.prepareStatement(iSql);
            pstmt.setString(1, pd.getWriter());
            pstmt.setString(2, pd.getTitle());
            pstmt.setString(3, pd.getContent());
            pstmt.setString(4, pd.getPw());
            pstmt.setString(5, pd.getIp());
            pstmt.setInt   (6, ref);
            pstmt.setInt   (7, re_step);
            pstmt.setInt   (8, re_level);
            pstmt.setString(9, pd.getImage()); 
            
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return result;
    }

    /** 2. 글 목록 (페이징) */
    public List<GalleryDTO> getGalleryList(int start, int end) {
        List<GalleryDTO> list = new ArrayList<>();
        int limit  = end - start + 1;
        int offset = start - 1;
        String sql =
            "SELECT num,writer,title,pw,regdate,ref,re_step,re_level,content,ip,readcnt " +
            "FROM Gallery " +
            "ORDER BY ref DESC,re_step ASC " +
            "LIMIT ? OFFSET ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            pstmt.setInt(2, offset);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                GalleryDTO dto = new GalleryDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setPw(rs.getString("pw"));
                dto.setRegdate(rs.getDate("regdate").toString());
                dto.setReadcnt(rs.getInt("readcnt"));
                dto.setRef(rs.getInt("ref"));
                dto.setRe_step(rs.getInt("re_step"));
                dto.setRe_level(rs.getInt("re_level"));
                dto.setContent(rs.getString("content"));
                dto.setIp(rs.getString("ip"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    /** 3. 글 보기 */
    public GalleryDTO getGallery(int num) {
        GalleryDTO dto = null;
        String sql = "SELECT * FROM Gallery WHERE num = ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new GalleryDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setRegdate(rs.getDate("regdate").toString());
                dto.setReadcnt(rs.getInt("readcnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return dto;
    }

    /** 4. 조회수 증가 */
    public void increaseReadcnt(int num) {
        String sql = "UPDATE Gallery SET readcnt = readcnt + 1 WHERE num = ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
    }

    /** 5. 글 수정 */
    public int updateGallery(GalleryDTO dto) {
        int res = 0;
        String sql = "UPDATE Gallery SET title = ?, content = ? WHERE num = ? AND pw = ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setInt(3, dto.getNum());
            pstmt.setString(4, dto.getPw());
            res = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return res;
    }

    /** 6. 글 삭제 */
    public int deleteGallery(int num, String pw) {
        int res = 0;
        String sql = "DELETE FROM Gallery WHERE num = ? AND pw = ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            pstmt.setString(2, pw);
            res = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return res;
    }

    /** 7. 전체 글 개수 */
    public int getArticleCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Gallery";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return count;
    }
}